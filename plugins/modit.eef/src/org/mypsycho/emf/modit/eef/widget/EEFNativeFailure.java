/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2012-2020. All rights reserved.
 */
package org.mypsycho.emf.modit.eef.widget;

import org.eclipse.eef.common.ui.api.IEEFFormContainer;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Label;

/**
 * Stub for EEF native widget failure.
 *
 * @author nperansin
 * @since 2020-11-16
 */
public class EEFNativeFailure implements EEFNativeWidget {

    private final String message;

    /**
     * Default constructor.
     *
     * @param message to display
     */
    public EEFNativeFailure(String message) {
        this.message = message;
    }

    @Override
    public void refresh(Access it) {
    }

    @Override
    public Control createControl(Composite parent, IEEFFormContainer formContainer) {
        Label result = new Label(parent, SWT.NONE);
        result.setText(message);
        return result;
    }

    @Override
    public void activate(Access it) {
    }

    @Override
    public void desactivate() {
    }

    @Override
    public void setEnabled(boolean isEnabled) {
    }

}
