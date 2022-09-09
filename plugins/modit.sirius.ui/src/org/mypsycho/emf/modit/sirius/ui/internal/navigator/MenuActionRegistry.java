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
package org.mypsycho.emf.modit.sirius.ui.internal.navigator;

import java.util.Collection;
import java.util.stream.Collectors;

import org.eclipse.emf.common.notify.impl.AdapterImpl;
import org.eclipse.emf.ecore.util.EcoreUtil;
import org.eclipse.sirius.business.api.session.Session;
import org.eclipse.sirius.business.api.session.SessionListener;
import org.eclipse.sirius.business.api.session.SessionManagerListener;
import org.eclipse.sirius.viewpoint.description.Viewpoint;
import org.mypsycho.emf.modit.sirius.ui.Activator;
import org.mypsycho.emf.modit.sirius.ui.navigator.ModellingActionProvider;
import org.osgi.framework.BundleContext;
import org.osgi.framework.InvalidSyntaxException;

/**
 *
 * @author nperansin
 */
public class MenuActionRegistry extends AdapterImpl implements SessionListener {

	public static class Factory extends SessionManagerListener.Stub {
		@Override
		public void notifyAddSession(Session newSession) {
			newSession.addListener(new MenuActionRegistry(newSession));
		}
	}
	
	public static ModellingActionProvider getProvider(Session session) {
		return session.getSessionResource().eAdapters().stream()
				.filter(it -> it instanceof MenuActionRegistry)
				.map(it -> ((MenuActionRegistry) it).current)
				.findFirst().orElse(null);
	}
	

	private final Session session;
	private ModellingActionProvider current;

	public MenuActionRegistry(Session session) {
		this.session = session;
	}
	
	@Override
	public void notify(int changeKind) {
		if (changeKind == SessionListener.OPENED) {
			current = getApplicableProvider(session);
			if (current != null) {
				setTarget(session.getSessionResource());
				getTarget().eAdapters().add(this);
			}
		} else if (changeKind == SessionListener.CLOSING) {
			session.getSessionResource().eAdapters().remove(this);
		} // else TODO listen to VP registry. ?

	}
	
	@Override
	public boolean isAdapterForType(Object type) {
		return ModellingActionProvider.class.equals(type);
	}

	private ModellingActionProvider getApplicableProvider(Session session) {
		try {
			// Using property of Component
			Collection<Viewpoint> vps = session.getSelectedViewpoints(false);
			String filter = "(|" // 'OR' ldap expression 
					+ vps.stream()
						.map(it -> '(' 
							+ ModellingActionProvider.VP_ATTRIBUTE 
							+ EcoreUtil.getURI(it).path() + ')')
						.collect(Collectors.joining()) 
					+ ")";
			BundleContext bc = Activator.getInstance().getBundle().getBundleContext();
			return bc.getServiceReferences(ModellingActionProvider.class, filter)
				.stream() // sorted by prority ??
				.map(it -> bc.getService(it))
				.findFirst()
				.orElse(null);
			// BundleContext
		} catch (InvalidSyntaxException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
	}

}
