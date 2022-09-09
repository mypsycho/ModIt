/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2012-2020. All rights reserved.
 */

package com.huawei.sirius.autosar.common.properties;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EStructuralFeature;

import autosar40.genericstructure.generaltemplateclasses.arobject.ARObject;

/**
 * Registry of Properties pages.
 *
 * @author nperansin
 * @since 2020-07-23
 */
public class PropertiesPageRegistry {
    /** Priority for upper page. */
    public static final int FIRST = 0;

    /** Priority for upper page. */
    public static final int DEFAULT = 100;

    /** Priority for lower page. */
    public static final int LAST = 1_000;

    /** Hiddens feature for a specific class: empty list means all objects */
    private final Map<EStructuralFeature, List<EClass>> hiddens = new HashMap<>();

    private final List<EStructuralFeature> customizeds = new ArrayList<>();

    private final Map<PropertiesPage, Integer> orderings = new HashMap<>();

    private final List<PropertiesPage> pages = new ArrayList<>();

    // Indexing accelerates grouping of features on page display.
    private Map<EStructuralFeature, String> featureIndexes;

    /**
     * Once all pages are register, features need to be indexed for a fast usage and
     * page to be ordered.
     */
    public void init() {
        featureIndexes = new HashMap<>();
        getPages().forEach(page -> {
            page.init();
            page.getFeatures().forEach(it -> featureIndexes.put(it, page.getName()));
        });
        Collections.sort(pages, Comparator.comparingInt(it -> orderings.get(it)));
    }

    /**
     * Indicates if a feature should be displayed in page.
     *
     * @param editedType of element
     * @param feature to edit
     * @param pageName to display
     * @return true if applicable
     * @throws IllegalStateException if registry is not indexed.
     */
    public boolean isInPage(EClass editedType, EStructuralFeature feature, String pageName) {
        if (featureIndexes == null) {
            throw new IllegalStateException("Registry is not indexed");
        }
        return pageName != null
            ? pageName.equals(featureIndexes.get(feature))
            : !featureIndexes.containsKey(feature)
                && !isHidden(editedType, feature)
                && !isCustomized(feature);
    }

    /**
     * Sets provided feature as hidden.
     *
     * @param feature to hide
     */
    public void hide(EStructuralFeature feature) {
        hiddens.put(feature, Collections.emptyList());
    }

    /**
     * Sets provided feature as hidden for a sub set of classes.
     *
     * @param feature to hide
     * @param applicables classes
     */
    public void hide(EStructuralFeature feature, EClass... applicables) {
        hiddens.put(feature, Arrays.asList(applicables));
    }

    /**
     * Declares a feature as a custom field.
     *
     * @param feature to hide
     */
    public void custom(EStructuralFeature feature) {
        customizeds.add(feature);
    }

    /**
     * Returns if a feature is editable for a given type.
     *
     * @param editedType of element
     * @param feature to display
     * @return true if hidden.
     */
    public boolean isHidden(EClass editedType, EStructuralFeature feature) {
        List<EClass> hiddenTypes = hiddens.get(feature);
        return hiddenTypes != null
            && (hiddenTypes.isEmpty()
                || hiddenTypes.stream().anyMatch(it -> it.isSuperTypeOf(editedType)));
    }

    /**
     * Registers a page.
     *
     * @param page of property
     * @param priority of page
     */
    public void register(PropertiesPage page, int priority) {
        orderings.put(page, priority);
        pages.add(page);
    }

    /**
     * Returns the pages.
     *
     * @return ordered pages
     */
    public List<PropertiesPage> getPages() {
        return pages;
    }

    /**
     * Returns true if a page must be display for value.
     *
     * @param value to test
     * @param pageName to display (null for default)
     * @return true if needed
     */
    public boolean isPageApplicable(EObject value, String pageName) {
        if (pageName == null) {
            // default page is always visible
            return value instanceof ARObject;
        }
        for (PropertiesPage page : pages) {
            if (pageName.equals(page.getName())) {
                return page.isVisibleFor(value);
            }
        }
        // unknown page ...
        return false;
    }

    /**
     * Returns true if the field is customized.
     *
     * @param it to evaluate
     * @return true custom
     */
    public boolean isCustomized(EStructuralFeature it) {
        return customizeds.contains(it);
    }

}
