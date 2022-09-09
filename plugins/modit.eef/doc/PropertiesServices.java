/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2012-2020. All rights reserved.
 */

package com.huawei.sirius.autosar.common.properties;

import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EAttribute;
import org.eclipse.emf.ecore.EEnumLiteral;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EReference;
import org.eclipse.emf.ecore.EStructuralFeature;
import org.eclipse.emf.ecore.util.EcoreUtil;
import org.eclipse.emf.edit.provider.ItemPropertyDescriptor;

import com.huawei.sirius.autosar.common.validation.ChoiceOfValues;

/**
 * Service for generic properties edition.
 * <p>
 * Keep in mind that Sirius Properties: does not support method not starting by
 * EObjects;
 * always provide selection as List for List Widget.
 * </p>
 *
 * @author nperansin
 * @since 2020-06-24
 */
public class PropertiesServices {

    /**
     * Return the choice of values for the object and reference
     *
     * @param context Current object
     * @param eRef EMF reference
     * @return list of values that can be chosen to set the reference on context
     */
    public static Collection<?> getPropertyChoiceOfValue(EObject context, EReference eRef) {
        Collection<?> constrainedValues = ChoiceOfValues.applyRule(eRef, context);

        if (constrainedValues != null) {
            return constrainedValues;
        }
        // On default implementation, we should use:
        // new EditingDomainServices().
        //   getPropertyDescriptorForFeature(context, eRef)
        //   .getChoiceOfValues(context)
        // But default AUTOSAR explicitly prevent recursive pattern search.
        // Huawei regards this as an error.
        // See: autosar40.util.Autosar40TraversalHelper.Autosar40TraveralSwitch#caseARObject(ARObject)
        // When finding an element, it is considered childless.

        // So let's use default Ecore implementation.

        //do not return elements whose proxy resolution failed
        return ItemPropertyDescriptor.getReachableObjectsOfType(context,
            eRef.getEType()).stream().filter(o -> !o.eIsProxy())
            .collect(Collectors.toList());
    }

    // Called services
    /**
     * Test if object can be moved inside its containing list
     *
     * @param it Object
     * @param dir direction -1= towards head, 1= towards tail
     * @return true if the object can be moved in the specified direction, false
     *     otherwise
     */
    public static boolean canMoveInContainer(EObject it, int dir) {
        EList<EObject> siblings = getContainingList(it);
        return canMove(siblings, siblings.indexOf(it), dir);
    }

    /**
     * Move the object in its containing list
     *
     * @param it Object
     * @param dir direction -1= towards head, 1= towards tail
     * @return the moved object
     */
    public static EObject moveInContainer(EObject it, int dir) {
        moveReference(getContainingList(it), it, dir);
        return it;
    }

    /**
     * Move the first element in selections in the reference in the specified
     * direction
     *
     * @param owner Owner object
     * @param ref Reference in which the element will be moved
     * @param selections List of elements, only the first one will be moved
     * @param dir direction -1= towards head, 1= towards tail
     */
    public static void moveReference(EObject owner, EReference ref, List<EObject> selections,
            int dir) {
        if (selections.isEmpty()) {
            return;
        }
        moveReference(getReferenceList(owner, ref), selections.get(0), dir);
    }

    /**
     * Remove elements from the specified reference
     *
     * @param owner Owner object
     * @param ref Reference from which elements will be removed
     * @param select Elements to be removed
     */
    public static void removeReference(EObject owner, EReference ref, List<?> select) {
        getReferenceList(owner, ref).removeAll(select);
    }

    // Convenient methods

    /**
     * Return the contents of the containing reference as a list
     *
     * @param it Current object
     * @return the contents of the reference containing object
     */
    public static EList<EObject> getContainingList(EObject it) {
        return getReferenceList(it.eContainer(), EReference.class.cast(it.eContainingFeature()));
    }

    /**
     * Returns the contents of a reference as a list
     *
     * @param it Parent object
     * @param ref Reference
     * @return contents of reference for object it
     */
    @SuppressWarnings("unchecked" /* EMF API */)
    public static EList<EObject> getReferenceList(EObject it, EReference ref) {
        // java generic side effect
        // EReference can only hold EObject
        return (EList<EObject>) it.eGet(ref);
    }

    /**
     * Tests if an object at specified index within a list can be moved in the
     * specified direction.
     *
     * @param siblings List of siblings
     * @param index of element to be moved
     * @param dir direction -1= towards head, 1= towards tail
     * @return true if it can be moved, false otherwise
     */
    private static boolean canMove(List<?> siblings, int index, int dir) {
        return index != -1 && 0 <= index + dir && index + dir < siblings.size();
    }

    /**
     * Moves an object of a list in the specified direction.
     * <p>
     * No effect if the object is not in the list or cannot be moved.
     * </p>
     *
     * @param <T> type of list
     * @param siblings List of all siblings (including select)
     * @param select Object to be moved
     * @param dir direction -1= towards head, 1= towards tail
     */
    static <T> void moveReference(EList<T> siblings, T select, int dir) {
        int index = siblings.indexOf(select);
        if (!canMove(siblings, index, dir)) {
            return;
        }

        siblings.move(index + dir, select);
    }

    /**
     * Returns the message of Dialog for selecting element.
     *
     * @param feature to set selected value.
     * @return message
     */
    public static String getSelectElementMessage(EStructuralFeature feature) {
        return "Select an instance of " + feature.getEType().getName() + " for the "
            + feature.getName() + " reference.";
    }

    /**
     * Returns the title of Dialog for selecting element.
     *
     * @param feature to set selected value.
     * @return message
     */
    public static String getSelectElementTitle(EStructuralFeature feature) {
        return "Select " + feature.getEType().getName();
    }

    /**
     * Set an enumerated value to attribute with enumeration.
     * <p>
     * if value is null, feature is unsetted.
     * </p>
     *
     * @param target to change
     * @param feat to apply
     * @param value to set
     * @return target
     */
    public static EObject setEnumValue(EObject target, EAttribute feat, Object value) {
        if (value == null) {
            // We do not update the value if it is already unset
            // Bug HUAWEIASGE-410
            if (target.eIsSet(feat)) {
                target.eUnset(feat);
            }
        } else if (value instanceof EEnumLiteral) {
            target.eSet(feat, ((EEnumLiteral) value).getInstance());
        } else {
            target.eSet(feat, value);
        }

        return target;
    }

    /**
     * Returns the value of the feature of null otherwise.
     * <p>
     * EMF returns default value when unset. This method returns null.
     * </p>
     *
     * @param target to evaluate
     * @param feature to evaluate
     * @return true if set
     */
    public static Object getOptionalValue(EObject target, EAttribute feature) {
        return target.eIsSet(feature)
            ? target.eGet(feature)
            : null;
    }

    /**
     * Set the value if not null or if null, unset the value.
     *
     * @param target to edit
     * @param feature to edit
     * @param value of feature
     * @return target
     */
    public static Object setOptionalValue(EObject target, EAttribute feature, Object value) {
        if (value == null) {
            target.eUnset(feature);
        } else {
            target.eSet(feature, value);
        }
        return target;
    }

    /**
     * Set the value if not null or if null, unset the value from textual field.
     * <p>
     * If feature expected a constraint value (number for example) exception can
     * raise.
     * </p>
     *
     * @param target to edit
     * @param feature to edit
     * @param text of value
     * @return target
     */
    public static Object setOptionalText(EObject target, EAttribute feature, String text) {
        boolean isString = String.class.equals(feature.getEType().getInstanceClass());
        Object value;

        if (text == null) {
            value = null;
        } else if (isString) {
            value = text;
        } else {
            String content = text.trim();
            if (content.isEmpty()) {
                value = null;
            } else {
                value = EcoreUtil.createFromString(feature.getEAttributeType(), content);
            }
        }

        if (value == null) {
            target.eUnset(feature);
        } else {
            target.eSet(feature, value);
        }
        return target;
    }

}
