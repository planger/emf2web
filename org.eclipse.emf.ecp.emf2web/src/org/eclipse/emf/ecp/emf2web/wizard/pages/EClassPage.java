/*******************************************************************************
 * Copyright (c) 2014-2015 EclipseSource Muenchen GmbH and others.
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 * Stefan Dirix - initial API and implementation
 *
 *******************************************************************************/
package org.eclipse.emf.ecp.emf2web.wizard.pages;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EClassifier;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecp.emf2web.wizard.ViewModelExportWizard;
import org.eclipse.emf.edit.provider.ComposedAdapterFactory;
import org.eclipse.emf.edit.ui.provider.AdapterFactoryLabelProvider;
import org.eclipse.jface.viewers.ArrayContentProvider;
import org.eclipse.jface.viewers.CheckStateChangedEvent;
import org.eclipse.jface.viewers.CheckboxTableViewer;
import org.eclipse.jface.viewers.ICheckStateListener;
import org.eclipse.jface.wizard.IWizard;
import org.eclipse.jface.wizard.WizardPage;
import org.eclipse.swt.SWT;
import org.eclipse.swt.layout.FillLayout;
import org.eclipse.swt.widgets.Composite;

public class EClassPage extends WizardPage implements IOnEnterWizardPage {

	private CheckboxTableViewer eClassTableViewer;
	private Resource ecoreResource;

	private final Set<EClass> selectedEClasses;

	/**
	 * Create the wizard.
	 */
	public EClassPage() {
		super("wizardPage");
		setTitle("EClass Selection");
		setDescription("Select at least one EClass to export");

		selectedEClasses = new HashSet<EClass>();
	}

	/**
	 * Create contents of the wizard.
	 *
	 * @param parent
	 */
	@Override
	public void createControl(Composite parent) {
		final Composite container = new Composite(parent, SWT.NULL);

		setControl(container);
		container.setLayout(new FillLayout(SWT.HORIZONTAL));

		eClassTableViewer = CheckboxTableViewer.newCheckList(container,
			SWT.BORDER | SWT.FULL_SELECTION);
		eClassTableViewer
		.addCheckStateListener(new EClassTableViewerICheckStateListener());
		eClassTableViewer.setContentProvider(new ArrayContentProvider());

		final ComposedAdapterFactory composedAdapterFactory = new ComposedAdapterFactory(
			ComposedAdapterFactory.Descriptor.Registry.INSTANCE);
		final AdapterFactoryLabelProvider labelProvider = new AdapterFactoryLabelProvider(
			composedAdapterFactory);

		eClassTableViewer.setLabelProvider(labelProvider);

		setPageComplete(false);
	}

	public void setNewResource(Resource ecoreResource) {
		this.ecoreResource = ecoreResource;
		setPageComplete(false);

		final List<EClass> eClassList = new ArrayList<EClass>();
		for (final Iterator<EObject> it = ecoreResource.getAllContents(); it
			.hasNext();) {
			final EObject object = it.next();
			if (!(object instanceof EPackage)) {
				continue;
			}
			final EPackage ePackage = (EPackage) object;
			for (final EClassifier eclassifier : ePackage.getEClassifiers()) {
				if (eclassifier instanceof EClass) {
					eClassList.add((EClass) eclassifier);
				}
			}
		}

		Collections.sort(eClassList, new Comparator<EClass>() {
			@Override
			public int compare(EClass arg0, EClass arg1) {
				return arg0.getName().compareTo(arg1.getName());
			}
		});

		selectedEClasses.clear();
		eClassTableViewer.setInput(eClassList);
	}

	private ViewModelExportWizard getExportWizard() {
		final IWizard wizard = getWizard();
		if (wizard instanceof ViewModelExportWizard) {
			return (ViewModelExportWizard) wizard;
		} else {
			return null;
		}
	}

	private class EClassTableViewerICheckStateListener implements
	ICheckStateListener {
		@Override
		public void checkStateChanged(CheckStateChangedEvent event) {
			if (event.getChecked()) {
				selectedEClasses.add((EClass) event.getElement());
			} else {
				selectedEClasses.remove(event.getElement());
			}

			if (selectedEClasses.size() > 0 && !isPageComplete()) {
				setPageComplete(true);
			}
			if (selectedEClasses.size() == 0 && isPageComplete()) {
				setPageComplete(false);
			}
		}
	}

	public Set<EClass> getSelectedEClasses() {
		return selectedEClasses;
	}

	@Override
	public void onEnterPage() {
		if (ecoreResource == null) {
			if (getExportWizard() != null) {
				setNewResource(getExportWizard().getEcoreResource());
			}
		}
	}
}
