/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2012-2020. All rights reserved.
 */

package com.huawei.sirius.autosar.ui.handlers;

import org.eclipse.core.commands.AbstractHandler;
import org.eclipse.core.commands.ExecutionEvent;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.ui.handlers.HandlerUtil;

import com.huawei.sirius.autosar.core.tree.node.TreeNode;

/**
 * Abstract base class for handlers
 *
 * @author nperansin
 * @since 2020-06-23
 */
public abstract class AbstractDesignElementHandler extends AbstractHandler {
    /**
     * Return the data object for the selected tree node given an event
     *
     * @param event Execution event containing the selection
     * @return data of the selected tree node
     */
    protected Object getSelectedData(ExecutionEvent event) {
        return getSelectedData(HandlerUtil.getCurrentSelection(event));
    }

    /**
     * Return the data object for the selected tree node
     *
     * @param selection Current selection
     * @return data of the selected tree node
     */
    protected Object getSelectedData(ISelection selection) {
        if (selection instanceof IStructuredSelection) {
            if (!selection.isEmpty()) {
                return ((TreeNode<?>) (IStructuredSelection.class.cast(selection) ).getFirstElement())
                    .getData();
            }
        }
        return null;
    }
}
