package org.eclipse.emf.ecp.emf2web.export

import org.eclipse.emf.ecp.makeithappen.model.task.Gender
import org.eclipse.emf.ecp.makeithappen.model.task.TaskFactory
import org.eclipse.emf.ecp.makeithappen.model.task.TaskPackage
import org.junit.Before
import org.junit.Ignore
import org.junit.Test

import static org.junit.Assert.*
import java.util.Date
import java.util.GregorianCalendar
import javax.xml.datatype.DatatypeFactory
import java.util.Calendar

//TODOs
//timezone for dates important? currently skipped
//lower bound = 0 kann bei default value weggelassen werden
//id woher?
class EObjectJSonExporterTest {
	
	EObjectJSonExporter exporter
	
	@Before
	def void init() {
		exporter = new EObjectJSonExporter
	}
	
	@Ignore
	@Test
	def void testIsPrimitiveByte() {
		fail("Not implemented yet")
	}
	
	@Ignore
	@Test
	def void testIsPrimitiveShort() {
		fail("Not implemented yet")
	}
	
	@Test
	def testIsPrimitiveInt() {
		assertTrue(exporter.isPrimitive(TaskPackage.eINSTANCE.user_Heigth))
	}
	
	@Ignore
	@Test
	def void testIsPrimitiveLong() {
		fail("Not implemented yet")
	}
	
	@Ignore
	@Test
	def void testIsPrimitiveFloat() {
		fail("Not implemented yet")
	}
	
	@Test
	def testIsPrimitiveDouble() {
		assertTrue(exporter.isPrimitive(TaskPackage.eINSTANCE.user_Weight))
	}
	
	@Test
	def testIsPrimitiveBoolean() {
		assertTrue(exporter.isPrimitive(TaskPackage.eINSTANCE.user_Active))
	}
	
	@Ignore
	@Test
	def void testIsPrimitiveChar() {
		fail("Not implemented yet")
	}
	
	@Test
	def testIsPrimitiveString() {
		assertFalse(exporter.isPrimitive(TaskPackage.eINSTANCE.user_FirstName))
	}
	
	@Test
	def testExportEmptyStringEAttribute() {
		val user = TaskFactory.eINSTANCE.createUser
		val result = exporter.exportSingleEAttribute(user, TaskPackage.eINSTANCE.user_FirstName)
		assertEquals(emptyString, result);
	}
	
	def String emptyString() {
		'''
			"firstName": ""
		'''
	}
	
	@Test
	def testExportStringEAttribute() {
		val user = TaskFactory.eINSTANCE.createUser
		user.firstName = "Stefan"
		val result = exporter.exportSingleEAttribute(user, TaskPackage.eINSTANCE.user_FirstName)
		assertEquals(string, result);
	}
	
	def String string() {
		'''
			"firstName": "Stefan"
		'''
	}
	
	@Test
	def testExportEnumEAttribute() {
		val user = TaskFactory.eINSTANCE.createUser
		user.gender = Gender.MALE
		val result = exporter.exportSingleEAttribute(user, TaskPackage.eINSTANCE.user_Gender)
		assertEquals(eenum, result);
	}
	
	def String eenum() {
		'''
			"gender": "Male"
		'''
	}
	
	@Test
	def testExportBooleanAttribute() {
		val user = TaskFactory.eINSTANCE.createUser
		user.active=true
		val result = exporter.exportSingleEAttribute(user, TaskPackage.eINSTANCE.user_Active)
		assertEquals(eboolean, result);
	}
	
	def String eboolean() {
		'''
			"active": true
		'''
	}
	
	@Test
	def testExportEDateAttribute() {
		val user = TaskFactory.eINSTANCE.createUser
		val calendar = Calendar.getInstance();
		calendar.set(2012, 11, 11, 23, 0, 0)
		val date = calendar.time
		user.timeOfRegistration = date
		val result = exporter.exportSingleEAttribute(user, TaskPackage.eINSTANCE.user_TimeOfRegistration)
		assertEquals(date(), result);
	}
	
	def String date() {
		'''
			"timeOfRegistration": "2012-12-11T23:00:00"
		'''
	}
	
	@Test
	def testExportEmptyEDateAttribute() {
		val user = TaskFactory.eINSTANCE.createUser
		val result = exporter.exportSingleEAttribute(user, TaskPackage.eINSTANCE.user_TimeOfRegistration)
		assertEquals(emptyDate, result);
	}
	
	def String emptyDate() {
		'''
			"timeOfRegistration": ""
		'''
	}
	
	@Test
	def testExportDoubleAttribute() {
		val user = TaskFactory.eINSTANCE.createUser
		user.weight = 70.1
		val result = exporter.exportSingleEAttribute(user, TaskPackage.eINSTANCE.user_Weight)
		assertEquals(eDouble, result);
	}
	
	def String eDouble() {
		'''
			"weight": 70.1
		'''
	}
	
	@Test
	def testExportIntAttribute() {
		val user = TaskFactory.eINSTANCE.createUser
		user.heigth = 174
		val result = exporter.exportSingleEAttribute(user, TaskPackage.eINSTANCE.user_Heigth)
		assertEquals(eInt, result);
	}
	
	def String eInt() {
		'''
			"heigth": 174
		'''
	}
	
	@Test
	def testExportXMLDateAttribute() {
		val user = TaskFactory.eINSTANCE.createUser
		val calendar = new GregorianCalendar();
		calendar.set(2012, 10, 11, 23, 0, 0)
		val xmlGregorianCalendar = DatatypeFactory.newInstance().newXMLGregorianCalendar(calendar);
		user.dateOfBirth = xmlGregorianCalendar
		val result = exporter.exportSingleEAttribute(user, TaskPackage.eINSTANCE.user_DateOfBirth)
		assertEquals(xmlDate(), result);
	}
	
	def String xmlDate() {
		'''
			"dateOfBirth": "2012-11-11T23:00:00"
		'''
	}
	
	@Test
	def testExportEmptyXMLDateAttribute() {
		val user = TaskFactory.eINSTANCE.createUser
		val result = exporter.exportSingleEAttribute(user, TaskPackage.eINSTANCE.user_DateOfBirth)
		assertEquals(emptyXmlDate(), result);
	}
	
	def String emptyXmlDate() {
		'''
			"dateOfBirth": ""
		'''
	}
	


	
}