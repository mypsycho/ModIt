/*******************************************************************************
 * Copyright (c) 2022 Nicolas PERANSIN.
 * This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License 2.0
 * which accompanies this distribution, and is available at
 * https://www.eclipse.org/legal/epl-2.0/
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 *    Nicolas PERANSIN - initial API and implementation
 *******************************************************************************/
package org.mypsycho.emf.modit.dw.dummyworld.design;

import org.mypsycho.emf.modit.sirius.ui.navigator.DefaultModellingActionProvider;
import org.mypsycho.emf.modit.sirius.ui.navigator.ModellingActionProvider;
import org.osgi.service.component.annotations.Component;

/**
 *
 * @author nperansin
 */
@Component(
		service = ModellingActionProvider.class,
		property = {
				ModellingActionProvider.VP_PROPERTY 
					+ DwDesignActivator.PLUGIN_ID + '/' + DummyWorldDesign.VP_NAME
		})
public class DwActionProvider extends DefaultModellingActionProvider {

}
