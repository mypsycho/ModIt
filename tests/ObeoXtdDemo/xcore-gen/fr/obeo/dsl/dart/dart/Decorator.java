/**
 */
package fr.obeo.dsl.dart.dart;


/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Decorator</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link fr.obeo.dsl.dart.dart.Decorator#getSelector <em>Selector</em>}</li>
 * </ul>
 *
 * @see fr.obeo.dsl.dart.dart.DartPackage#getDecorator()
 * @model interface="true" abstract="true"
 * @generated
 */
public interface Decorator extends AngularType {
	/**
	 * Returns the value of the '<em><b>Selector</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <p>
	 * If the meaning of the '<em>Selector</em>' attribute isn't clear,
	 * there really should be more of a description here...
	 * </p>
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Selector</em>' attribute.
	 * @see #setSelector(String)
	 * @see fr.obeo.dsl.dart.dart.DartPackage#getDecorator_Selector()
	 * @model unique="false"
	 * @generated
	 */
	String getSelector();

	/**
	 * Sets the value of the '{@link fr.obeo.dsl.dart.dart.Decorator#getSelector <em>Selector</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Selector</em>' attribute.
	 * @see #getSelector()
	 * @generated
	 */
	void setSelector(String value);

} // Decorator
