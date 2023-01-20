/*******************************************************************************
 * Copyright (c) 2020 Nicolas PERANSIN.
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
package org.mypsycho.emf.modit.sirius.tests

import java.nio.file.Paths
import org.junit.Test
import static org.junit.Assert.assertEquals

/**
 *
 * @author nperansin
 */
class FileComparatorTest {
	
	// Specific
	protected static val TEST_PATH = Paths.get("resource/FileComparatorTest").toAbsolutePath
	
	
	@Test
	def void compareDiffentFiles() {
		useCase("folder1/File1.txt", "folder1/File2.txt")
			.forEach[ println("compareDiffentFiles: " + it) ]
	}
	
	@Test
	def void compareSameFiles() {
		useCase("folder1/File1.txt", "folder1/File1.txt")
			.forEach[ assertEquals(0, size) ]
	}
	
	
	@Test
	def void compareDifferentFolders() {
		useCase("folder1", "folder2")
			.forEach[ println("compareDifferentFolders: " + it) ]
	}
	
	@Test
	def void compareSameFolders() {
		useCase("folder1", "folder1").forEach[ assertEquals(0, size) ]
	}
	
	@Test
	def void compareTypes() {
		useCase("folder1/File1.txt", "folder2")
			.forEach[ 
				assertEquals(1, size)
				assertEquals(FileComparator.Type.type, values.head.key)
			]
	}
	
	
	def useCase(String path1, String path2) {
		#[ path1 -> path2, path2 -> path1 ]
		.map[
			new FileComparator(
				TEST_PATH.resolve(key),
				TEST_PATH.resolve(value)
			).exec
		]

	}
	
}