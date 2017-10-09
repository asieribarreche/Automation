'===========================================================
' @ Created by: Globe Norte
' @ Name: BuscarVuelo
' @ Description: Find flight
' @ Date: 17/01/2017
'===========================================================

'Input Parameters
iOrigen = "Madrid, España (MAD)"'fgetDataParameter(slitOrigen, slitBuscarComprar)
iDestino = "Barcelona, Esàña (BCN)"'fgetDataParameter(slitDestino, slitBuscarComprar)
iPasajero = "2"'fgetDataParameter(slitNumPasajero, slitBuscarComprar)
iVuelo = "IdaVuelta" 'Parameter("flight")
slitURL = "https://tickets.vueling.com"

'Load ObjectRepository
'initializeRepository("BuscarVuelo")

'Load and Check Page
loadPage()

'Choose the flight type
flightType()

'Select Airports


Browser("Vueling").Page("Vueling").WebEdit("AvailabilitySearchInputSearchV").Click
SendKeysShell ("m")
SendKeysShell ("{ENTER}")
Browser("Vueling").Page("Vueling").WebEdit("AvailabilitySearchInputSearchV_2").Click

SendKeysShell ("b")
SendKeysShell ("{ENTER}")

'selectTravelAirport iOrigen,"AvailabilitySearchInputSearchView$T"
'selectTravelAirport iDestino,"AvailabilitySearchInputSearchView$T_2"
'
'Select the flight date
'selectDate()

'Select passenger number
NumPassenger(iPasajero)

'Find all flight
findFlight()


'======================= Functions ============================

Function loadPage()

	
	SystemUtil.Run "iexplore.exe", slitURL

	Browser("Vueling").Page("Vueling").Sync


	If Browser("Vueling").Page("Vueling").Link("standardLogo").Exist Then
		
		
	else
		
		
		Environment("Execution") = "KO"
	End If

	
	
End Function


Function flightType()

	
	

	If iVuelo = "Ida" Then	
		Browser("Vueling").Page("Vueling").WebElement("Solo ida").Click
	Else
		Browser("Vueling").Page("Vueling").WebElement("Ida y vuelta").Click
	End If

	
	
	
End Function



Function selectTravelAirport(airport, objName)
	
	Browser("Vueling").Page("Vueling").WebEdit(objName).click
	Browser("Vueling").Page("Vueling").WebEdit(objName).Set airport 
	selectCity airport 
	wait 3
	
End Function

Function selectDate()

	For Iterator = 1 To 2 Step 1
		Browser("Vueling").Page("Vueling").WebElement("Siguiente").Click
	Next

	Reporter.Filter = rfEnableAll

	wait(2)

	Set objDesc=Description.Create
	objDesc("micclass").value="link"

	set objChild = Browser("Vueling").Page("Vueling").WebTable("mes_3").ChildObjects(objDesc)

'	wait(3)

	If objChild.count < 1 Then
		
		Environment("Execution") = "KO"
	else
		objChild(objChild.count-1).click
		Wait (3)
	End If

	If iVuelo <> "Ida" Then
		Set objDesc=Description.Create
		objDesc("micclass").value="link"

		set objChild = Browser("Vueling").Page("Vueling").WebTable("mes_4").ChildObjects(objDesc)
	
		If objChild.count < 1 Then
			
			Environment("Execution") = "KO"
		else
			objChild(objChild.count-1).click
		End If
	End If
	
End Function


Function NumPassenger(num)
	Browser("Vueling").Page("Vueling").Link("2").Click

	'Browser("Vueling").Page("Vueling").WebList("NumPassenger").Select num
	wait(3)
	
End Function


Function findFlight()

	
	Browser("Vueling").Page("Vueling").WebElement("Buscar vuelos").Click


	
	
	
	'ReportExcel("Ok")
	Environment("Execution") = "Ok"

End Function




Function selectCity(city)
	
	set linksoDesc = Description.create
	linksoDesc ("micclass").value = "WebElement"
	linksoDesc ("css").value = "UL LI A"

	texto = MID(city, 1, (InStr(1, city, ","))-1) 
	linksoDesc ("innertext").value = texto & ".*"


	Set allChildrenlinks = Browser("Vueling").Page("Vueling").ChildObjects(linksoDesc)
	For i = 0 to allChildrenlinks.Count -1 
		If allChildrenlinks(i).getRoProperty("innertext") = city Then
			Setting.WebPackage("ReplayType") = 2
			
			allChildrenlinks(i).Click
			
			Setting.WebPackage("ReplayType") = 1
			Exit For 
		End If
	Next

End Function


Sub SendKeysShell(teclas)
	Set WshShell = CreateObject("WScript.Shell")
	WshShell.SendKeys teclas
End Sub


