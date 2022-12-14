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
package org.mypsycho.emf.modit.sirius

import java.io.LineNumberReader
import java.nio.charset.Charset
import java.nio.file.FileVisitResult
import java.nio.file.Path
import java.nio.file.Paths
import java.nio.file.SimpleFileVisitor
import java.nio.file.attribute.BasicFileAttributes
import java.util.HashMap
import java.util.Map
import org.eclipse.xtend.lib.annotations.Accessors

import static extension java.nio.file.Files.*
import static org.junit.Assert.assertEquals
import java.util.Collections

/**
 *
 * @author nperansin
 */
class FileComparator extends SimpleFileVisitor<Path> {
	
	static val ROOT = Paths.get(".")
	
	enum Type {
		content, whitespace, type, sourceOnly, targetOnly
	}
	
	static val DEFAULT_CHARSET = Charset.forName("UTF-8")
	
	@Accessors val Path source
	
	@Accessors val Path target
	
	@Accessors
	var (Path)=>Charset sourceCharset = [ DEFAULT_CHARSET ]

	@Accessors
	var (Path)=>Charset targetCharset = [ DEFAULT_CHARSET ]
	
	var Map<Path, Pair<Type, String>> result
	
	new (Path source, Path target) {
		this.source = source
		this.target = target
	}
	
	def setSourceCharset(Charset value) {
		sourceCharset = [ value ]
	}
	
	def setTargetCharset(Charset value) {
		sourceCharset = [ value ]
	}
	
	def Map<?extends Path, ?extends Pair<Type, String>> exec() {
		result = new HashMap
		
		if (!source.exists) {
			throw new IllegalStateException("Source does not exist")
		}
		
		source.walkFileTree(this)	

		result
	}
	
	override preVisitDirectory(Path dir, BasicFileAttributes attrs) {
		val opposite = target.resolve(source.relativize(dir))
		if (!dir.isTypeEquals(opposite)) {
			return FileVisitResult.SKIP_SUBTREE
		}
		
		opposite.list
			.map[ dir.resolve(fileName) ]
			.filter[ !exists ]
			.forEach[ issue(Type.targetOnly, null) ]
		
		FileVisitResult.CONTINUE
	}
	
	override visitFile(Path file, BasicFileAttributes attrs) {
		val opposite = target.resolve(source.relativize(file))
		if (!file.isTypeEquals(opposite)) {
			return FileVisitResult.CONTINUE
		}
		
		try(val srcReader = file.toReader(sourceCharset))
		try(val tgtReader = opposite.toReader(targetCharset)) {
			var diffOnSpace = false

	        var srcLine = srcReader.readLine
	        var tgtLine = tgtReader.readLine
	        
	        while (srcLine !== null && tgtLine !== null) {
	            if (srcLine.equals(tgtLine)) {
	            	// next line
					srcLine = srcReader.readLine
	            	tgtLine = tgtReader.readLine
	            } else {
	            	diffOnSpace = true // at least
	            	srcLine	= srcLine.trimLine(srcReader)
	            	tgtLine	= tgtLine.trimLine(tgtReader)
	            	
	            	if (srcLine !== null && tgtLine !== null) {
	            		if (!srcLine.equals(tgtReader)) { 
	            			// compare only non empty 
	            			val srcIndex = srcReader.lineNumber
	            			val tgtIndex = tgtReader.lineNumber
	            		
	            			file.issue(Type.content, 
	            				if (srcIndex == tgtIndex)
	            					'''line:«srcIndex»'''
	            				else '''source:«srcIndex»;target:«tgtIndex»'''
	            			)
	            			return FileVisitResult.CONTINUE
            			}
            			srcLine = srcReader.readLine.trimLine(srcReader)
	            		tgtLine = tgtReader.readLine.trimLine(tgtReader)
	            	}

	            }
	        }
	        
	        if (tgtLine.trimLine(tgtReader) !== null) {
	        	file.issue(Type.content, '''Target has extra lines at «tgtReader.lineNumber»''')
	        } else if (srcLine.trimLine(srcReader) !== null) {
	        	file.issue(Type.content, '''Source has extra lines at «srcReader.lineNumber»''')
	        } else if (diffOnSpace) {
	        	file.issue(Type.whitespace, null)
	        }
	    }
		
		FileVisitResult.CONTINUE
	}
		
	def trimLine(String line, LineNumberReader reader) {
		for (var it = line?.trim; it !== null; it = reader.readLine?.trim) {
			if (!empty) {
				return it
			}
		}
		null
	}
	
	def toReader(Path it, (Path)=>Charset cs) {
		new LineNumberReader(newBufferedReader(cs.apply(it)))
	}
	
	
	def isTypeEquals(Path src, Path tgt) {
		if (src.isDirectory != tgt.isDirectory || !tgt.exists) {
			src.issue(
				if (!tgt.exists) Type.sourceOnly
				else Type.type, 
				null)
			false
		} else true
	}
	
	def void issue(Path it, Type type, String detail) {
		val relative = source.relativize(it)
		result.put(!relative.toString.empty ? relative : ROOT, type -> detail)
	}

	static def void assertIdentical(Path expected, Path value) {
		assertEquals('''Files are different {«expected.toAbsolutePath», «value.toAbsolutePath»}''', 
			Collections.emptyMap, new FileComparator(expected, value).exec
		)
	}
	
}