#parser resultados UFT xml a formato junit

$total_duration =0;
$total_name ="NAME";
$total_failures =0;

#param([string]$ruta_xml_origen, [string]$ruta_xml_junit)
Write-Host "Origen: $ruta_xml_origen"
Write-Host "Salida: $ruta_xml_junit"

#$ruta_xml_junit = "C:\Users\globe\Box Sync\Andoni Muruamendiaraz\Proyectos\CONSULTING\XML\reporte.xml"

#Create a new XML File with config root node
[System.XML.XMLDocument]$oXMLDocument=New-Object System.XML.XMLDocument

# Nuevo nodo "testsuite"
[System.XML.XMLElement]$oXMLRoot=$oXMLDocument.CreateElement("testsuites")

# Append as child to an existing node
$oXMLDocument.appendChild($oXMLRoot)


Get-ChildItem $ruta_xml_origen -Filter *.xml | 

Foreach-Object {

                #Write-Host $_.FullName
                
                #inicializacion
                $pasado = 0
                $fallado = 0
                $passed = 0
                $failed = 0
                $ruta_xml_origen = $_.FullName
                $TC_info_xpath = "/Results/ReportNode/Data/"

                [System.Xml.XmlDocument]$file = new-object System.Xml.XmlDocument

                #carga del fichero XML salida de UFT
                $file.load($ruta_xml_origen)

                #ruta al nombre del script UFT
                $TC_name= $file.SelectSingleNode("/Results/ReportNode/Data/Name").innertext
                $TC_duration= $file.SelectSingleNode("/Results/ReportNode/Data/Duration").innertext
                $TC_result= $file.SelectSingleNode("/Results/ReportNode/Data/Result").innertext
                
   [System.XML.XMLElement]$oXMLRootChild=$oXMLRoot.appendChild($oXMLDocument.CreateElement("testsuite"))

                # Añadir atributos al testsuite: nombre, duracion, total steps
                $oXMLRootChild.SetAttribute("name",$TC_name)        
                $oXMLRootChild.SetAttribute("duration",$TC_duration)               
                $oXMLRootChild.SetAttribute("failures",$TC_result)   

                $total_duration = $total_duration + [int]$TC_duration
                $total_failures = $total_failures + $(If ($TC_result -eq "Done") {0} Else {1}) 
                
}

$oXMLRoot.SetAttribute("name",$total_name)        
$oXMLRoot.SetAttribute("duration",$total_duration)               
$oXMLRoot.SetAttribute("failures",$total_failures) 

# Save File
$oXMLDocument.Save($ruta_xml_junit)

