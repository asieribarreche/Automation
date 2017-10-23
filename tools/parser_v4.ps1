###########################################################
#     Parse UFT run_results.xml to a JUnit format XML     #
###########################################################

# Get external parameters
$origin_xml_directory = $args[0]
$ruta_xml_junit = $args[1]
$func_name = $args[2]
#$origin_xml_directory = "C:\Users\globe\Box Sync\Andoni Muruamendiaraz\Proyectos\CONSULTING\XML\go"
#$ruta_xml_junit = "C:\Users\globe\Box Sync\Andoni Muruamendiaraz\Proyectos\CONSULTING\reporte.xml"

# Init testsuite variables
$total_duration = 0;
$total_failures = 0;

# Create a new XML File with config root node
[System.XML.XMLDocument] $oXMLDocument = New-Object System.XML.XMLDocument

# New node "testsuite"
[System.XML.XMLElement] $oXMLRoot = $oXMLDocument.CreateElement("testsuite")

# Append as child to an existing node
$oXMLDocument.appendChild($oXMLRoot)

#Iterate throught all the files (testcases) on a directory
Get-ChildItem $origin_xml_directory |
Foreach-Object {
	
	# Access to results file
	$origin_xml_directory = $($_.FullName + "\Report\run_results.xml")

	# Create new XML object
	[System.Xml.XmlDocument]$file = new-object System.Xml.XmlDocument

	# Load result file into XML object
	$file.load($origin_xml_directory)

	# Get the useful information of the results
	$TC_name= $file.SelectSingleNode("/Results/ReportNode/Data/Name").innertext
	$TC_duration= $file.SelectSingleNode("/Results/ReportNode/Data/Duration").innertext
	$TC_result= $file.SelectSingleNode("/Results/ReportNode/Data/Result").innertext

	# Add testcase node
	[System.XML.XMLElement]$oXMLRootChild=$oXMLRoot.appendChild($oXMLDocument.CreateElement("testcase"))

	# Add previous info to the output JUnit XML
	$oXMLRootChild.SetAttribute("name",$TC_name)        
	$oXMLRootChild.SetAttribute("time",$TC_duration)               
	$oXMLRootChild.SetAttribute("failures",$TC_result)   

	# Store the current TC info into variables to summary them into the functionality Testsuite
	$total_duration = $total_duration + [int]$TC_duration
	$total_failures = $total_failures + $(If ($TC_result -eq "Done") {0} Else {1}) 
	
}

# Store the summarized info in the testsuite
$oXMLRoot.SetAttribute("name",$func_name)        
$oXMLRoot.SetAttribute("time",$total_duration)               
$oXMLRoot.SetAttribute("failures",$total_failures) 

# Save the output JUnit file
$oXMLDocument.Save($($ruta_xml_junit + "\" + $func_name + "_junit_results.xml"))



