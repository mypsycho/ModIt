package org.mypsycho.emf.modit.sirius.ui;
import org.eclipse.ui.plugin.AbstractUIPlugin;
import org.mypsycho.emf.modit.sirius.ui.view.PropertiesGlobalActionBinder;
import org.osgi.framework.BundleContext;

public class Activator extends AbstractUIPlugin {

	private static Activator instance;
	
	
	private PropertiesGlobalActionBinder actionBinder;
	
	@Override
	public void start(BundleContext context) throws Exception {
		super.start(context);
		instance = this;
		actionBinder = new PropertiesGlobalActionBinder();
		// context.getServiceReferences(null, PLUGIN_PREFERENCE_SCOPE)
	}

	
	@Override
	public void stop(BundleContext context) throws Exception {
		super.stop(context);
		actionBinder.dispose();
		actionBinder = null;
		instance = null;
	}
	
	public static Activator getInstance() {
		return instance;
	}
}
