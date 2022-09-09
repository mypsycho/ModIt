/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2012-2020. All rights reserved.
 */

package com.huawei.sirius.autosar.ui.views;

import java.lang.reflect.InvocationTargetException;
import java.util.concurrent.atomic.AtomicReference;
import java.util.stream.Stream;

import org.eclipse.core.resources.IMarker;
import org.eclipse.core.resources.IProject;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IAdaptable;
import org.eclipse.core.runtime.IPath;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EValidator;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.jface.dialogs.ProgressMonitorDialog;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.sirius.business.api.modelingproject.ModelingProject;
import org.eclipse.sirius.business.api.session.Session;
import org.eclipse.sirius.business.api.session.SessionManager;
import org.eclipse.sphinx.emf.util.EcoreResourceUtil;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.ui.IEditorLauncher;
import org.eclipse.ui.PartInitException;
import org.eclipse.ui.PlatformUI;

import com.huawei.sirius.common.ResourceUtils;

/**
 * Handler for showing element in Autosar model.
 * <p>
 * Problem view requires an Eclipse editor to show a marker source. <br/>
 * This redirect the open request to update selection in Design Explorer View.
 * </p>
 * <p>
 * Using only editor descriptor has a limit: if user forces another editor, this
 * editor is not activated. <br/>
 * For a more complete solution, create a menuContribution for
 * 'popup:org.eclipse.ui.menus.showInMenu'. <br/>
 * More detail on implementation in class
 * org.eclipse.ui.internal.ShowInMenu of org.eclipse.ui.workbench plugin.
 * </p>
 *
 * @author nperansin
 * @since 2020-06-24
 */
public class DesignExplorerLauncher implements IEditorLauncher {
    private static final String SESSION_EXTENSION = "aird";

    private static final String AR_PROTOCOL = "ar:/";

    private static Shell getDefaultShell() {
        return PlatformUI.getWorkbench().getActiveWorkbenchWindow().getShell();
    }

    private void notifyFailure(String message, Object value) {
        String text = message + ": " + value;
        MessageDialog.openInformation(getDefaultShell(), "Open Autosar Design", text);
        throw new IllegalArgumentException(text);
    }

    @Override
    public void open(IPath file) { // file is a system path
        @SuppressWarnings("deprecation") // Deprecation is not relevant: IEditorLauncher is old API.
        IProject project = Stream
            .of(ResourcesPlugin.getWorkspace().getRoot().findFilesForLocation(file))
            .map(it -> it.getProject())
            .filter(it -> ResourceUtils.isOpenedModelingProject(it))
            .findFirst()
            .orElse(null);

        if (project == null) {
            notifyFailure("File is not in a valid project", file);
        }

        open(ModelingProject.asModelingProject(project).get(),
            !SESSION_EXTENSION.equals(file.getFileExtension())
                ? getSelectedMarker()
                : null);
    }

    /**
     * Open the Design explorer view on the object targeted by the marker
     *
     * @param mproject Modeling project
     * @param marker Marker object
     */
    public void open(ModelingProject mproject, IMarker marker) {
        Object selection = getCurrentSelection(mproject, marker);

        Display.getDefault().syncExec(() -> {
            try {
                DesignExplorerView view = DesignExplorerView.class.cast(PlatformUI.getWorkbench()
                    .getActiveWorkbenchWindow().getActivePage()
                    .showView(DesignExplorerView.VIEW_ID));

                view.selectInTree(selection);
            } catch (PartInitException e) {
                throw new UnsupportedOperationException(e);
            }
        });
    }

    private Session getOpenSession(ModelingProject project) {
        Session session = project.getSession();
        if (session != null && session.isOpen()) {
            return session;
        }
        AtomicReference<Session> result = new AtomicReference<>(session);
        try {
            new ProgressMonitorDialog(getDefaultShell()).run(true, false, monitor -> {
                if (session == null) {
                    result.set(SessionManager.INSTANCE
                        .getSession(project.getMainRepresentationsFileURI(monitor).get(), monitor));
                } else {
                    session.open(monitor);
                }
            });
        } catch (InvocationTargetException | InterruptedException e) {
            notifyFailure("Cannot reach modeling session", project.getProject());
        }
        return result.get();
    }

    private Object getCurrentSelection(ModelingProject mproject, IMarker marker) {
        // There is no #equals(_) in ModelingProject...
        // So Eclipse project is used to provide identifiable selection.
        Object defaultSelection = mproject.getProject();
        Session session = getOpenSession(mproject);

        if (marker == null) {
            return defaultSelection;
        }

        String filePath = marker.getResource().getFullPath().toString();
        String arObjectPath;
        try {
            arObjectPath = String.class.cast(marker.getAttribute(EValidator.URI_ATTRIBUTE));
            if (arObjectPath == null) {
                return defaultSelection;
            }
        } catch (CoreException e) { //
            return defaultSelection;
        }

        String uriValue;
        if (arObjectPath.startsWith(AR_PROTOCOL)) {
            // Note: Cannot use URI.createPlatformPluginURI(_)
            // Sphinx separators ('#', '?') must not be encoded
            uriValue = "platform:/resource" + filePath
                + arObjectPath.substring(AR_PROTOCOL.length());
        } else { // unlikely: Marker would come from another framework must still use EValidator key.
            uriValue = arObjectPath;
        }

        ResourceSet resSet = session.getTransactionalEditingDomain().getResourceSet();
        EObject reference = EcoreResourceUtil.getEObject(resSet, URI.createURI(uriValue));

        return reference != null
            ? reference
            : defaultSelection;
    }

    /**
     * Returns an {@link IMarker} if the current selection in the workbench can be
     * adapted in an {@link IMarker}
     *
     * @return an {@link IMarker} or <code>null</code>
     */
    private IMarker getSelectedMarker() {
        ISelection wbSelection = PlatformUI.getWorkbench().getActiveWorkbenchWindow()
            .getSelectionService().getSelection();

        if (!(wbSelection instanceof IStructuredSelection)) {
            return null;
        }

        Object userSelection = ((IStructuredSelection) wbSelection).getFirstElement();
        if (userSelection instanceof IMarker) {
            return (IMarker) userSelection;
        }
        if (userSelection instanceof IAdaptable) {
            IAdaptable adaptable = (IAdaptable) userSelection;
            return adaptable.getAdapter(IMarker.class);
        }
        return null;
    }

}
