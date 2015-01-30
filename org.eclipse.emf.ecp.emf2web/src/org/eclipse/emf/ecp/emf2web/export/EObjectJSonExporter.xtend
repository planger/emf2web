/*******************************************************************************
 * Copyright (c) 2014-2015 EclipseSource Muenchen GmbH and others.
 * 
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 * 
 * Contributors:
 * Johannes Faltermeier - initial API and implementation
 * 
 *******************************************************************************/
package org.eclipse.emf.ecp.emf2web.export


import org.eclipse.emf.ecore.EAttribute
import org.eclipse.emf.ecore.EObject
import javax.xml.datatype.XMLGregorianCalendar
import java.util.Date
import java.text.SimpleDateFormat
import org.eclipse.emf.ecore.EReference
import java.util.List

class EObjectJSonExporter {
	
	def public String exportEObjectToJSon(EObject eObject) {
		'''
		{
			«FOR attribute : eObject.eClass.EAllAttributes SEPARATOR ','»
				«IF attribute.many»
					«exportMultiEAttribute(eObject,attribute)»
				«ENDIF»
				«IF !attribute.many»
					«exportSingleEAttribute(eObject,attribute)»
				«ENDIF»
			«ENDFOR»
			«FOR reference : eObject.eClass.EAllReferences SEPARATOR ','»
				«IF reference.many»
					«exportMultiEReference(eObject, reference)»
				«ENDIF»
				«IF !reference.many»
					«exportSingleReference(eObject,reference)»
				«ENDIF»
			«ENDFOR»
		}
		'''
	}
	
	def exportMultiEReference(EObject eObject, EReference reference) {
		val list = typeof(List).cast(eObject.eGet(reference));
		'''
			"«reference.name»": [
				«FOR Object object : list SEPARATOR ','»
						«exportEObjectToJSon(typeof(EObject).cast(object))»
				«ENDFOR»
			]
		'''
	}
	
	def exportSingleReference(EObject eObject, EReference reference) {
		val object = typeof(EObject).cast(eObject.eGet(reference));
		'''
			"«reference.name»": «exportEObjectToJSon(typeof(EObject).cast(object))»
		'''
	}
	
	def String exportMultiEAttribute(EObject eObject, EAttribute attribute) {
		val list = typeof(List).cast(eObject.eGet(attribute))
		'''
			"«attribute.name»": [
				«FOR Object object : list SEPARATOR ','»
					«getFormattedValue(attribute, '''object''')»
				«ENDFOR»
			]
		'''
	}
	
	def String exportSingleEAttribute(EObject eObject, EAttribute attribute) {
		val value = getValue(eObject, attribute)
		'''
			"«attribute.name»": «value»
		'''
	}
	
	def String getValue(EObject eObject, EAttribute attribute) {
		var value = eObject.eGet(attribute)
		val instanceClass = attribute.getEAttributeType().getInstanceClass()
		if (value == null) {
			value = ""
		} else if (typeof(XMLGregorianCalendar).isAssignableFrom(instanceClass)) {
			val xmlDateValue = typeof(XMLGregorianCalendar).cast(value);
			val date = xmlDateValue.toGregorianCalendar().time
			value = getDate(date)
		} else if (typeof(Date).isAssignableFrom(instanceClass)) {
			val date = typeof(Date).cast(value);
			value = getDate(date)
		}
		getFormattedValue(attribute, '''«value»''')
	}
	
	def String getFormattedValue(EAttribute attribute, String actualValue) {
		var value = actualValue
		if (!isPrimitive(attribute)) {
			'''
				"«value»"
			'''
		} else {
			'''
				«value»
			'''
		}
	}
	
	def String getDate(Date date) {
		//TODO how to handle timezone?
		val dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss")
		dateFormat.format(date)
	}
	
	def boolean isPrimitive(EAttribute attribute) {
		val instanceClass = attribute.getEAttributeType().getInstanceClass()
		if (typeof(String).isAssignableFrom(instanceClass)) {
			return false;
		}
		instanceClass.isPrimitive
	}
	
}