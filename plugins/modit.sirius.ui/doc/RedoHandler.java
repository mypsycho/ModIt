/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2012-2020. All rights reserved.
 */

package com.huawei.sirius.autosar.ui.handlers;

import org.eclipse.core.commands.ExecutionEvent;
import org.eclipse.core.commands.ExecutionException;
import org.eclipse.emf.common.command.CommandStack;
import org.eclipse.sirius.business.api.session.Session;

/**
 * Command handler to handle redo.
 *
 * @author nperansin
 * @since 2020-06-23
 */
public class RedoHandler extends OnSessionCommandHandler {

    @Override
    protected boolean isEnabled(Session session) {
        return session.getTransactionalEditingDomain().getCommandStack().canRedo();
    }

    @Override
    public Object execute(ExecutionEvent event) throws ExecutionException {
        getSessionFromSelection(event).ifPresent((session) -> {
            CommandStack stack = session.getTransactionalEditingDomain().getCommandStack();
            if (stack.canRedo()) {
                stack.redo();
            }
        });
        return null;
    }
}
