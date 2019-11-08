<!--- http://wwvv.codersrevolution.com/blog/using-osgi-to-load-a-conflicting-jar-into-lucee-server --->
<cfparam name="step" default="1">
<cfparam name="form.file" default="">
<cfparam name="currentpath" default="#getdirectoryFromPath(getCUrrentTemplatePath())#">

<!--- Initialize Required Directoryies --->
<cfset tmp = currentPath & "tmp/">
<cfset trg = currentPath & "trg/">
<cfset src = currentPath & "src/">

<cfif directoryExists(tmp)>
	<cfdirectory action="delete" directory="#tmp#" recurse="true">
</cfif>
<cfif !directoryExists(tmp)>
	<cfdirectory action="create" directory="#tmp#">
</cfif>
<cfif !directoryExists(trg)>
	<cfdirectory action="create" directory="#trg#">
</cfif>
<cfif !directoryExists(src)>
	<cfdirectory action="create" directory="#src#">
</cfif>

<cfoutput>

<cfdirectory action="list" directory="#src#" name="filelist" filter="*.jar">
<cfif filelist.recordcount==0>
	<h2>there is no jar files in the source directory #currentPath#.</h2>
	<cfabort>
</cfif>

<div>

	<p>
		<strong>Bundle-SymbolicName</strong><br/>
		A name that identifies the bundle uniquely.
	</p>
	<p>
		<strong>Bundle-Version</strong><br/>
		This header describes the version of the bundle, and enables multiple versions of a bundle to be active concurrently in the same framework instance.
	</p>
	<p>
		<strong>Bundle-Activator</strong><br/>
		This header notifies the bundle of lifecycle changes.
	</p>
	<p>
		<strong>Import-Package</strong><br/>
		This header declares the external dependencies of the bundle that the OSGi Framework uses to resolve the bundle. Specific versions or version ranges for each package can be declared. In this example manifest file, the org.apache.commons.logging package is required at Version 1.0.4 or later.
	</p>
	<p>
	<strong>Export-Package</strong><br/>
	This header declares the packages that are visible outside the bundle. If a package is not declared in this header, it is visible only within the bundle.
</div>

<cfif step EQ 1>
	<h2>Step 1: Select File To Convert</h2>
	<form method="post" autocomplete="off">
		<input type="hidden" name="step" value="2">
		<table>
		<tr>
			<th align="left">
				<label for="file">File</label>
			</th>
			<th align="left">

				<select name="file" id="file">
					<option value="">All</option>
					<cfloop query="#filelist#">
						<cfif filelist.type=="FILE">
							<option value="#filelist.name#">#filelist.name#</option>
						</cfif>
					</cfloop>
				</select>
			</th>
		</tr>
		<tr>
			<th align="left">&nbsp;</th>
			<th align="left">
				<button type="submit" name="generate">Generate</button>
			</th>
		</tr>
		</table>
	</form>

<cfelseif step EQ 2>
	<form method="post" autocomplete="off">
		<input type="hidden" name="step" value="3">
		<cfset convertlist = "" >
		<cfif form.file EQ "">
			<cfloop query="#filelist#">
				<cfif filelist.type EQ "FILE">
					<cfset convertlist = listAPpend(convertlist,filelist.name)>
				</cfif>
			</cfloop>
		<cfelse>
			<cfset convertlist = form.file >
		</cfif>

		<h2>Step 2: Specify record detail(s)</h2>
		<table cellspacing="0">

		<cfloop list="#convertlist#" index="i" item="listitem">
			<tr>
				<td colspan="2"><hr/></td>
			</tr>
			<tr>
				<th align="left">
					<label for="file_#i#">File</label>
				</th>
				<th align="left">
					<input type="hidden" name="file_#i#" value="#listitem#">
					<input type="text" name="filedisplay_#i#" id="filedisplay_#i#" value="#listitem#" disabled>
				</th>
			</tr>
			<tr>
				<th align="left">
					<label for="name_#i#">Name: *</label>
				</th>
				<td>
					<input type="hidden" name="keynumber_#i#" value="#i#">
					<input type="text" name="name_#i#" id="name_#i#" placeholder="example" value="#replacenocase(listitem, ".jar","")#" required>
				</td>
			</tr>
			<tr>
				<th align="left">
					<label for="version_#i#">Version: *</label>
				</th>
				<td>
					<input type="text" name="version_#i#" id="version_#i#" placeholder="1.2.3.4" required>
				</td>
			</tr><tr>
				<th align="left">
					<label for="bundleActivationPolicy_#i#">bundleActivationPolicy</label>
				</th>
				<td>
					<input type="text" name="bundleActivationPolicy_#i#" id="bundleActivationPolicy_#i#" placeholder="lazy">
				</td>
			</tr>
			<tr>
				<th align="left">
					<label for="bundleActivator_#i#">bundleActivator</label>
				</th>
				<td>
					<input type="text" name="bundleActivator_#i#" id="bundleActivator_#i#" placeholder="none">
				</td>
			</tr>
			<tr>
				<th align="left">
					<label for="importPackage_#i#">importPackage</label>
				</th>
				<td>
					<input type="text" name="importPackage_#i#" id="importPackage_#i#" placeholder="org.lucee.whatelse">
				</td>
			</tr>
			<tr>
				<th align="left">
					<label for="exportPackage_#i#">exportPackage</label>
				</th>
				<td>
					<input type="text" name="exportPackage_#i#" id="exportPackage_#i#" placeholder="org.lucee.susi">
				</td>
			</tr>
			<tr>
				<th align="left">
					<label for="dynamicImportPackage_#i#">dynamicImportPackage</label>
				</th>
				<td>
					<input type="text" name="dynamicImportPackage_#i#" id="dynamicImportPackage_#i#" placeholder="org.lucee.whatever">
				</td>
			</tr>
			<tr>
				<th align="left">
					<label for="requireBundle_#i#">requireBundle</label>
				</th>
				<td>
					<input type="text" name="requireBundle_#i#" id="requireBundle_#i#" placeholder="susi.sorglos;bundle-version=1.2.3.4">
				</td>
			</tr>
			<tr>
				<th align="left">
					<label for="requireBundleFragment_#i#">requireBundleFragment</label>
				</th>
				<td>
					<input type="text" name="requireBundleFragment_#i#" id="requireBundleFragment_#i#" placeholder="susi.sorglos.whatever;bundle-version=1.2.3.4">
				</td>
			</tr>
			<tr>
				<th align="left">
					<label for="fragmentHost_#i#">fragmentHost</label>
				</th>
				<td>
					<input type="text" name="fragmentHost_#i#" id="fragmentHost_#i#" placeholder="example.base">
				</td>
			</tr>
			<tr>
				<th align="left">
					<label for="ignoreExistingManifest_#i#">ignoreExistingManifest</label>
				</th>
				<td>
					<input type="radio" value="true" name="ignoreExistingManifest_#i#"> True &mdash;
					<input type="radio" value="false" name="ignoreExistingManifest_#i#" checked="true"> False
				</td>
			</tr>
		</cfloop>
		<tr>
			<td>&nbsp;</td>
			<td>
				<input type="hidden" name="listlen" value="#i#">
				<a href="jar2osgi.cfm">&laquo; Back</a> &nbsp;&nbsp;&nbsp;
				<button type="submit" name="generate">Generate</button>
			</td>
		</tr>
		</table>
	</form>
<cfelse>

	<cfset jars = []>
	<cfloop from="1" to="#form.listlen#" index="i">
		<cfset jar = {
			file : form["file_#i#"]
			, name : form["name_#i#"]
			, version : form["version_#i#"]
			, bundleActivationPolicy : structkeyexists(form, "bundleActivationPolicy_#i#") ? trim(form["bundleActivationPolicy_#i#"]) : ''
			, bundleActivator : structkeyexists(form, "bundleActivator_#i#") ? trim(form["bundleActivator_#i#"]) : ''
			, importPackage : structkeyexists(form, "importPackage_#i#") ? trim(form["importPackage_#i#"]) : ''
			, exportPackage : structkeyexists(form, "exportPackage_#i#") ? trim(form["exportPackage_#i#"]) : ''
			, dynamicImportPackage : structkeyexists(form, "dynamicImportPackage_#i#") ? trim(form["dynamicImportPackage_#i#"]) : ''
			, requireBundle : structkeyexists(form, "requireBundle_#i#") ? trim(form["requireBundle_#i#"]) : ''
			, requireBundleFragment : structkeyexists(form, "requireBundleFragment_#i#") ? trim(form["requireBundleFragment_#i#"]) : ''
			, fragmentHost : structkeyexists(form, "fragmentHost_#i#") ? trim(form["fragmentHost_#i#"]) : ''
			, ignoreExistingManifest : ( structkeyexists(form, "ignoreExistingManifest_#i#") && form["ignoreExistingManifest_#i#"] == "true" ) ? true : false
		}>

		<cfset arrayAppend( jars, jar )>
	</cfloop>

	<!--- jars to ignore, that are used to load other jars needed. --->
	<cfset ignore={'javax.servlet.jar':'','org.mortbay.jetty.jar':'','railo-inst.jar':''}>

	<!--- build 3 party bundles --->

	<cfset pom="">
	<cfset dep="">
	<cfset req="">

	<cfloop array="#jars#" index="i" item="jar">
		<cfif structKeyExists(ignore,jar.name)>
			<cfcontinue>
		</cfif>
		<!--- if there is no info we simply copy the file --->
		<!--- <cfif !structKeyExists(versions,jars.name)>
			<cffile action="copy"
				source="#jars.directory#/#jars.name#"
				destination="#trg#/#jars.name#" nameconflict="overwrite">
			<cfcontinue>
		</cfif> --->

		<!--- create the bundle    FragmentHost="railo.core" --->
		<cfadmin action="buildBundle"
			name="#jar.name#"
			jar="#src##jar.file#"
			version="#jar.version#"
			bundleActivationPolicy="#jar.bundleActivationPolicy#"
			bundleActivator="#jar.bundleActivator#"
			exportPackage="#jar.exportPackage#"
			importPackage="#jar.importPackage#"
			fragmentHost="#jar.fragmentHost#"
			dynamicImportPackage="#jar.dynamicImportPackage#"
			requireBundle="#jar.requireBundle#"
			requireBundleFragment="#jar.requireBundleFragment#"
			ignoreExistingManifest="#jar.ignoreExistingManifest#"
			pom=true
			destination="#tmp#/#jar.file#">

			<!--- read it to get symbolic name and version in valid format --->
			<cfadmin action="readBundle"
				bundle="#tmp#/#jar.file#"
				returnvariable="bundle">
			<!--- change temporary name --->
			<cffile action="move"
					source="#tmp#/#jar.file#"
					destination="#trg#/#replace(bundle.SymbolicName,'.','-','all')#-#replace(bundle.Version,'.','-','all')#.jar">

			 #bundle.SymbolicName# -
			#jar.name# --> #trg#/#replace(bundle.SymbolicName,'.','-','all')#-#replace(bundle.Version,'.','-','all')#.jar<br>

			<cfset last=listLast(bundle.SymbolicName,'.')>
			<cfset len=listLen(bundle.SymbolicName,'.')>
			<cfif len GT 1>
				<cfset rest=reverse(listRest(list:reverse(bundle.SymbolicName),offset:1,delimiters:'.'))>
			<cfelse>
				<cfset rest=last>
			</cfif>
			<cfsavecontent variable="pom" trim>
				#pom#
				<!-- #bundle.SymbolicName# - #bundle.Version# -->
				<execution>
					<id>#bundle.SymbolicName#-#bundle.Version#</id>
					<phase>initialize</phase>
					<goals>
						<goal>install-file</goal>
					</goals>
					<configuration>
						<groupId>#rest#</groupId>
						<artifactId>#last#</artifactId>
						<version>#bundle.Version#</version>
						<packaging>jar</packaging>
						<createChecksum>true</createChecksum>
						<generatePom>true</generatePom>
						<localRepositoryPath>${dir.trg}</localRepositoryPath>
						<file>${dir.src}/#replace(bundle.SymbolicName,'.','-','all')#-#replace(bundle.Version,'.','-','all')#.jar</file>
					</configuration>
				</execution>
			</cfsavecontent>

			<cfsavecontent variable="dep" trim>
				#dep#
				<!-- #bundle.SymbolicName# - #bundle.Version# -->
				<dependency>
					<groupId>#rest#</groupId>
					<artifactId>#last#</artifactId>
					<type>jar</type>
					<version>#bundle.Version#</version>
					<scope>compile</scope>
				</dependency>
			</cfsavecontent>

			<!--- Require-bundle --->
			<cfscript>
				if(len(req)>0)req&=",
			";
				req&=" "&bundle.SymbolicName&";bundle-version="&bundle.Version;

			</cfscript>
		</cfloop>

		<h2>install file (for mvn-repo)</h2>
		<cfset echo(replace(replace(replace(pom,'	','&nbsp;&nbsp;&nbsp;','all'),'<','&lt;','all'),'
	','<br>','all'))>

		<h2>dependency (for core)</h2>

		<cfset echo(replace(replace(replace(dep,'	','&nbsp;&nbsp;&nbsp;','all'),'<','&lt;','all'),'
	','<br>','all'))>

		<h2>require-bundle</h2>

		<cfset echo("Require-Bundle:"&replace(replace(replace(req,'	','&nbsp;&nbsp;&nbsp;','all'),'<','&lt;','all'),'
	','<br>','all'))>

	<cfif directoryExists(tmp)>
		<cfdirectory action="delete" directory="#tmp#" recurse="true">
	</cfif>
</cfif>
</cfoutput>
