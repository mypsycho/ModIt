/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2012-2020. All rights reserved.
 */

package com.huawei.sirius.autosar.core.handlers;

import java.util.HashMap;
import java.util.Map;
import java.util.function.Predicate;

import org.eclipse.core.expressions.PropertyTester;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.sirius.business.api.modelingproject.ModelingProject;
import org.eclipse.sirius.viewpoint.DRepresentation;
import org.eclipse.sirius.viewpoint.DRepresentationDescriptor;

import com.huawei.sirius.autosar.common.project.AutosarProjectDescriptions;
import com.huawei.sirius.autosar.core.tree.node.EObjectTreeNode;
import com.huawei.sirius.autosar.core.tree.node.ModelingProjectTreeNode;
import com.huawei.sirius.autosar.core.tree.node.TreeNode;
import com.huawei.sirius.autosar.core.tree.node.physical.ClosedProjectTreeNode;
import com.huawei.sirius.autosar.core.tree.node.physical.FileTreeNode;
import com.huawei.sirius.autosar.core.tree.node.physical.FolderTreeNode;
import com.huawei.sirius.common.ResourceUtils;

import autosar40.autosartoplevelstructure.AUTOSAR;
import autosar40.genericstructure.generaltemplateclasses.arpackage.ARPackage;
import autosar40.genericstructure.generaltemplateclasses.arpackage.PackageableElement;
import autosar40.swcomponent.components.AtomicSwComponentType;

/**
 * This class provides properties for Eclipse plugin conditions to tests
 * actions.
 *
 * @author nperansin
 * @since 2020-06-23
 */
public class TreeNodePropertyTester extends PropertyTester {
    // XXX
    // Following properties are not effective:
    // Semantic types (isAtomicComponent, isPackageableElement, isPackage)
    // must be replace by arguments of isSemantic.

    // Following constants matches declaration in 'properties' list in extension point.
    private static final String IS_REPRESENTATION = "isRepresentation";
    private static final String IS_SEMANTIC = "isSemantic";
    private static final String IS_PROJECT = "isProject";
    private static final String IS_OPEN_PROJECT = "isOpenProject";
    private static final String IS_CLOSED_PROJECT = "isClosedProject";
    private static final String IS_FOLDER = "isFolder";
    private static final String IS_ARXML = "isArXml";
    private static final String IS_AUTHORIZED_FILE_FORMAT = "isAuthorizedFileFormat";
    private static final String IS_PHYSICAL = "isPhysical";
    private static final String IS_LOADING = "isLoading";
    private static final String IS_WORKING_FILE = "isWorkingFile";
    // Usefully only to complete 'not' operator or for any treenode
    private static final String IS_ANY = "isAny";

    // Deprecated
    private static final String IS_AUTOSAR = "isAutosar";
    private static final String IS_PACKAGEABLE_ELEMENT = "isPackageableElement";
    private static final String IS_PACKAGE = "isPackage";
    private static final String IS_ATOMIC_COMPONENT = "isAtomicComponent";

    private static Map<String, Predicate<TreeNode<?>>> config = new HashMap<>();

    static {
        config.put(IS_REPRESENTATION, receiver -> {
            Object data = receiver.getData();
            return data instanceof DRepresentationDescriptor || data instanceof DRepresentation;
        });

        // not testing data as virtual package can match
        config.put(IS_PROJECT, receiver -> receiver instanceof ModelingProjectTreeNode);
        config.put(IS_OPEN_PROJECT, receiver -> receiver instanceof ModelingProjectTreeNode
            && ResourceUtils
                .isSessionOpen(((ModelingProjectTreeNode) receiver).getData()));
        config.put(IS_CLOSED_PROJECT, receiver -> receiver instanceof ClosedProjectTreeNode);
        config.put(IS_FOLDER, receiver -> receiver instanceof FolderTreeNode);
        config.put(IS_ARXML, receiver -> receiver instanceof FileTreeNode
            && ResourceUtils.isArXml(((FileTreeNode) receiver).getData()));
        config.put(IS_AUTHORIZED_FILE_FORMAT, receiver -> receiver instanceof FileTreeNode
            && ResourceUtils
                .fileEndsWithAuthorizedFormat(((FileTreeNode) receiver).getData()));
        config.put(IS_PHYSICAL,
            receiver -> receiver instanceof FileTreeNode || receiver instanceof FolderTreeNode
                || receiver instanceof ClosedProjectTreeNode
                || receiver instanceof ModelingProjectTreeNode);
        config.put(IS_LOADING, receiver -> isProjectLoading(receiver));
        config.put(IS_WORKING_FILE, receiver -> receiver instanceof FileTreeNode
            && AutosarProjectDescriptions.isWorkingFile(((FileTreeNode) receiver).getData()));
        config.put(IS_SEMANTIC, receiver -> receiver instanceof EObjectTreeNode);

        config.put(IS_ATOMIC_COMPONENT,
            receiver -> receiver.getData() instanceof AtomicSwComponentType);
        config.put(IS_PACKAGEABLE_ELEMENT,
            receiver -> receiver.getData() instanceof PackageableElement);
        config.put(IS_PACKAGE,
            receiver -> receiver.getData() instanceof ARPackage);
        config.put(IS_AUTOSAR,
            receiver -> receiver.getData() instanceof AUTOSAR);

        config.put(IS_ANY, receiver -> true);
    }

    @Override
    public boolean test(Object receiver, String property, Object[] args, Object expectedValue) {
        if (receiver instanceof TreeNode<?>) {
            TreeNode<?> tested = (TreeNode<?>) receiver;
            return config.get(property).test(tested)
                && isTyped(tested.getData(), args);
        }
        return false;
    }

    private static final boolean isTyped(Object data, Object[] args) {
        if (args == null || args.length == 0) {
            return true;
        }
        if (!(data instanceof EObject)
            || args.length != 1
            || !(args[0] instanceof String)) {
            return false;
        }
        String expectedType = (String) args[0];
        EObject value = (EObject) data;
        EClass type = value.eClass();
        return isType(type, expectedType)
            || type.getEAllSuperTypes().stream().anyMatch(it -> isType(it, expectedType));
    }

    private static final boolean isType(EClass type, String expected) {
        return type.getName().equals(expected);
    }

    /**
     * Evaluates if the project node containing this node is loading.
     *
     * @param node the node to test
     * @return true if the project of the node is loading
     */
    public static boolean isProjectLoading(TreeNode<?> node) {
        if (node instanceof ModelingProjectTreeNode) {
            ModelingProject prj = ((ModelingProjectTreeNode) node).getData();
            return prj.getSession() != null && !ResourceUtils.isSessionOpen(prj);
        }
        return node != null && isProjectLoading(node.getParent());
    }
}
