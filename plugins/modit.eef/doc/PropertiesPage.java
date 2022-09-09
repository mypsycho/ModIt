/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2012-2020. All rights reserved.
 */

package com.huawei.sirius.autosar.common.properties;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EReference;
import org.eclipse.emf.ecore.EStructuralFeature;

/**
 * Description of specific PropertiesPage.
 *
 * @author nperansin
 * @since 2020-07-23
 */
public class PropertiesPage {
    /**
     * Registry of hidden features in properties view.
     */
    public interface PropertiesPageRegistry {
        /**
         * Sets provided feature as hidden.
         *
         * @param feature to hide
         */
        void hide(EStructuralFeature feature);

        /**
         * Sets provided feature as hidden for a sub set of classes.
         *
         * @param feature to hide
         * @param applicables classes
         */
        void hide(EStructuralFeature feature, EClass... applicables);
    }

    private final String name;

    private final String label;

    private final List<EStructuralFeature> features;

    /** Derived from features at initialization */
    private Set<Class<?>> applicables;

    /**
     * Derived from features at initialization.
     * Happens when only a specific group
     */
    private boolean emptyGroup;

    /**
     * Default constructor.
     *
     * @param id identifying the page used as text.
     * @param features to display
     */
    public PropertiesPage(String id, EStructuralFeature... features) {
        this(id, id, features);
    }

    /**
     * Default constructor.
     *
     * @param id identifying the page
     * @param text of page
     * @param features to display
     */
    public PropertiesPage(String id, String text, EStructuralFeature... features) {
        // we should put the text in i18n.
        name = id;
        label = text;
        // ArrayList is trimed with this constructor
        this.features = new ArrayList<>(Arrays.asList(features));
    }

    /**
     * Adds features to this page.
     * <p>
     * It can be performed only if page is initialized
     * </p>
     *
     * @param newFeatures to add
     * @throws IllegalStateException if page is initialized.
     */
    public void addFeatures(EStructuralFeature... newFeatures) {
        if (applicables != null) {
            // is initialized
            throw new IllegalStateException("Page is already initialized");
        }
        features.addAll(Arrays.asList(newFeatures));
    }

    /**
     * Returns the name.
     *
     * @return the name
     */
    public String getName() {
        return name;
    }

    /**
     * Returns the label.
     *
     * @return the label
     */
    public String getLabel() {
        return label;
    }

    /**
     * Returns group is empty.
     *
     * @return if group is empty
     */
    public boolean isEmptyGroup() {
        return emptyGroup;
    }

    /**
     * Returns the features.
     *
     * @return the features
     */
    public List<? extends EStructuralFeature> getFeatures() {
        return features;
    }

    /**
     * Returns if a group should be display for provided value.
     *
     * @param value to edit
     * @return true if applicable
     */
    public boolean isVisibleFor(EObject value) {
        return applicables.stream().anyMatch(it -> it.isInstance(value));
    }

    /**
     * Returns the applicables.
     *
     * @return the applicables
     */
    public Set<? extends Class<?>> getApplicables() {
        return applicables;
    }

    /**
     * Find the set of classes a collection of feature applies.
     * <p>
     * The set is not the common attraction, but there is no sub-classes of an other
     * element in the result.
     * </p>
     *
     * @param features to analyze
     * @return set of applicable classes
     */
    private static Set<Class<?>> findApplicableClasses(List<EStructuralFeature> features) {
        Set<Class<?>> result = new HashSet<>();

        for (EStructuralFeature feature : features) {
            Class<?> type = feature.getContainerClass();

            // not added if is a sub-type of applicables
            if (!result.stream().anyMatch(it -> it.isAssignableFrom(type))) {
                // remove sub-types
                result.removeIf(it -> type.isAssignableFrom(it));
                result.add(type);
            }
        }
        return result;
    }

    /**
     * Initializes derived fields.
     * <p>
     * Only pages registry should call this method.
     * </p>
     */
    void init() {
        applicables = findApplicableClasses(features);
        emptyGroup = features.stream().allMatch(it -> it instanceof EReference
            && ((EReference) it).isContainment());
    }

}
