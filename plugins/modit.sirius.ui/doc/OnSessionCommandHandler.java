/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2012-2020. All rights reserved.
 */

package com.huawei.sirius.autosar.ui.handlers;

import java.util.Collection;
import java.util.Optional;

import org.eclipse.core.commands.ExecutionEvent;
import org.eclipse.core.expressions.IEvaluationContext;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.sirius.business.api.modelingproject.ModelingProject;
import org.eclipse.sirius.business.api.session.Session;
import org.eclipse.ui.handlers.HandlerUtil;

import com.huawei.sirius.autosar.core.tree.node.TreeNode;

/**
 * Command handler working with Sirius session.
 *
 * @author nperansin
 * @since 2020-06-23
 */
public abstract class OnSessionCommandHandler extends AbstractDesignElementHandler {
    @Override
    public void setEnabled(Object evaluationContext) {
        if (evaluationContext instanceof Session) {
            setBaseEnabled(isEnabled((Session) evaluationContext));
        } else if (evaluationContext instanceof IEvaluationContext) {
            setEnabled(((IEvaluationContext) evaluationContext).getDefaultVariable());
        } else if (evaluationContext instanceof Collection) {
            Collection<?> selection = (Collection<?>) evaluationContext;
            if (selection.isEmpty()) {
                setBaseEnabled(false);
            } else {
                setEnabled(selection.iterator().next());
            }
        } else if (evaluationContext instanceof TreeNode) {
            setEnabled(((TreeNode<?>) evaluationContext).getData());
        } else if (evaluationContext instanceof ModelingProject) {
            setEnabled(((ModelingProject) evaluationContext).getSession());
        } else if (evaluationContext instanceof EObject) {
            // XXX For a wider integration, Session must belong to main session of AUTOSAR project
            setEnabled(Session.of((EObject) evaluationContext).orElse(null));
        } else {
            setBaseEnabled(false);
        }
    }

    /**
     * Check if this handler is enabled for the given session
     *
     * @param session Sirius session
     * @return true if handler is enabled, false otherwise
     */
    protected boolean isEnabled(Session session) {
        return session.isOpen();
    }

    /**
     * Return the session from the current selection
     *
     * @param event Execution event containing the current selection
     * @return the session corresponding to the current selection or null if there
     *     is none
     */
    protected Optional<Session> getSessionFromSelection(ExecutionEvent event) {
        Object selection = getSelectedData(HandlerUtil.getCurrentSelection(event));
        if (selection instanceof ModelingProject) {
            return Optional.of(((ModelingProject) selection).getSession());
        } else if (selection instanceof EObject) {
            return Session.of((EObject) selection);
        } else {
            return Optional.empty();
        }
    }

}
