<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
<meta charset="utf-8">
<link rel="shortcut icon" href="static/images/favicon.ico"
	type="image/x-icon">
<link rel="icon" href="static/images/favicon.ico" type="image/x-icon">
<link rel="stylesheet" href="static/css/metro-bootstrap.css">
<link href="static/css/iconFont.css" rel="stylesheet">
<link href="static/css/docs.css" rel="stylesheet">
<link href="static/js/prettify/prettify.css" rel="stylesheet">
<!-- Load JavaScript Libraries -->
<script src="static/js/jquery/jquery-2.1.1.js"></script>
<script src="static/js/jquery/jquery.widget.min.js"></script>
<script type="text/javascript" src="static/js/jsapi.js"></script>

<!-- Metro UI CSS JavaScript plugins -->
<script src="static/js/load-metro.js"></script>

<script type="text/javascript">
	google.load('visualization', '1.1', {
		packages : [ 'corechart','controls','table','motionchart' ]
	});
</script>
<script type="text/javascript">
	var yearPicker;
	var monthPicker;
	//google.setOnLoadCallback(drawVisualization);
	$(document).ready(function() {
		drawVisualization();
		drawMotionChart();
	});

	$(document).ready(function() {
		var state1 = yearPicker.getState();
		var state2 = monthPicker.getState();
		makeAjaxCall(state1.selectedValues[0],state2.selectedValues[0]);
	});

	function makeAjaxCall(year, month) {
		if (document.getElementById("Monthly").checked == true){
			$("#monthcontrol").hide();
		}else{
			$("#monthcontrol").show();
		}
		if (document.getElementById("Monthly").checked == true) {
			$.ajax({
				url : 'showHomeDashboard1.do',
				method : "POST",
				data : "year=" + year,
				success : function(response) {
					$("#subViewDiv").html(response);
				}
			});
		}
		if (document.getElementById("Weekly").checked == true) {
			$.ajax({
				url : 'showHomeDashboard2.do',
				method : "POST",
				data : "year=" + year + "&month=" + month,
				success : function(response) {
					$("#subViewDiv").html(response);
				}
			});
		}
	}
	
	function drawVisualization() {
		var datafeed = '<c:out value="${logdatafeed}"/>';
		datafeed = datafeed.replace(/&#039;/g, '\'');
		datafeed = eval("(" + datafeed + ")");
		var data = google.visualization.arrayToDataTable(datafeed);
		// Define a category picker control for the Year column
		yearPicker = new google.visualization.ControlWrapper({
			'controlType' : 'CategoryFilter',
			'containerId' : 'control1',
			'options' : {
				'filterColumnLabel' : 'Year',
				'ui' : {
					'labelStacking' : 'vertical',
					'allowNone' : false,
					'allowTyping' : false,
					'allowMultiple' : false
				}
			},
			'state' : {
				'selectedValues' : [ '<c:out value="${maxyear}"/>' ]
			}
		});
		// Define a category picker control for the Month column
		monthPicker = new google.visualization.ControlWrapper({
			'controlType' : 'CategoryFilter',
			'containerId' : 'monthcontrol',
			'options' : {
				'filterColumnLabel' : 'Month',
				'ui' : {
					'labelStacking' : 'vertical',
					'allowNone' : false,
					'allowTyping' : false,
					'allowMultiple' : false
				}
			},
			'state' : {
				'selectedValues' : [ '' ]
			}
		});
		// Define a table
		var table = new google.visualization.ChartWrapper({
			'chartType' : 'Table',
			'containerId' : 'chart_table',
			'options' : {
				'width' : '500px',
				'page' : 'enable',
				'pageSize' : 15,
				'pagingSymbols' : {
					prev : 'prev',
					next : 'next'
				},
				'pagingButtonsConfiguration' : 'auto'
			}
		});
		google.visualization.events.addListener(yearPicker, 'statechange',
				function() {
				    var state1 = yearPicker.getState();
				    var state2 = monthPicker.getState();
					makeAjaxCall(state1.selectedValues[0],state2.selectedValues[0]);
				});
		google.visualization.events.addListener(monthPicker, 'statechange',
				function() {
		    var state1 = yearPicker.getState();
		    var state2 = monthPicker.getState();
			makeAjaxCall(state1.selectedValues[0],state2.selectedValues[0]);
				});
		// Create a dashboard
		var dashboard1 = new google.visualization.Dashboard(document
				.getElementById('dashboard1')).bind([ yearPicker,monthPicker ], [ table ]);
		google.visualization.events.addListener(dashboard1, 'error', function (dashboard) { google.visualization.errors.removeAll(document.getElementById("dashboard1")); });
		google.visualization.events.addListener(control1, 'error',  function (err) { google.visualization.errors.removeError(err.id); }); 
		google.visualization.events.addListener(monthcontrol, 'error',  function (err) { google.visualization.errors.removeError(err.id); }); 
		dashboard1.draw(data);
	}

	$(document).ready(function() {
		$(document).ajaxStart(function() {
			$("#wait").css("display", "block");
		});
		$(document).ajaxComplete(function() {
			$("#wait").css("display", "none");
		});
	});

	$(document).ready(function() {
		$("input[name=report]:radio").change(function() {
			var state1 = yearPicker.getState();
			var state2 = monthPicker.getState();
			makeAjaxCall(state1.selectedValues[0],state2.selectedValues[0]);
		});
	});
	function drawMotionChart() {
	    var data = new google.visualization.DataTable();
	    data.addColumn('string', 'Tenant');
	    data.addColumn('date', 'Date');
	    data.addColumn('number', 'Usage Count');
	    data.addColumn('string', 'Storage Type');
	    data.addColumn('string', 'Service');
	    data.addRows([
	      ['ABC',  new Date (1988,0,1),225,'Google Drive', 'Smart Scan'],
	      ['XYZ', new Date (1989,0,1),456, 'Box.com', 'Remote Print'],
	      ['SDG', new Date (1988,0,1),550, 'One Drive', 'Remote Fax'],
	      ['HCL',  new Date (1989,6,1),157,'Box.com', 'Fax Linkage'],
	      ['IBM', new Date (1988,6,1),750,'Google Drive', 'GCP'],
	      ['GOOGLE', new Date (1990,6,1),678,'DropBox', 'Remote Print'],
	      ['ABC',  new Date (2013,2,11),225,'Google Drive', 'Smart Scan'],
	      ['XYZ', new Date (2014,2,10),456, 'Box.com', 'Remote Print'],
	      ['SDG', new Date (2014,5,10),550, 'One Drive', 'Remote Fax'],
	      ['HCL',  new Date (2014,5,1),157,'Box.com', 'Fax Linkage'],
	      ['IBM', new Date (2014,6,1),750,'Google Drive', 'GCP'],
	      ['GOOGLE', new Date (2015,6,1),678,'DropBox', 'Remote Print']
	    ]);
	    var chart = new google.visualization.MotionChart(document.getElementById('chart_div7'));

	    chart.draw(data, {width: 600, height:300});
	  }
</script>
<title>Data Automation & Visualization Dashboard 2.0</title>
</head>
<body class="metro">
	<jsp:include page="../views/header.jsp"></jsp:include>
	<!-- Start of container -->
	<div class="container" align="center">
		<div>
			<table>
				<tr>
					<td class="span3"
						style='vertical-align: top; background-color: #3D3D3D'>
						<jsp:include page="../views/sidebar.jsp"></jsp:include>
					</td>
					<td>
						<h2 id="__notice__">Summary of each service Report(
							accumulation of all companies):</h2>
						<div class="example">
							<table>
								<tr>
									<td><label for="Report" class="control-label input-group">Report
											Type</label>
										<div class="input-control radio inline-block"
											data-role="input-control">
											<label class="inline-block"> <input type="radio"
												name="report" id="Monthly" checked /> <span class="check"></span>Monthly
											</label>
													<label class="inline-block"> <input type="radio"
												name="report" id="Weekly"/><span class="check"></span>Weekly
											</label>
										</div></td>
									<td>
										<div id="dashboard1">
											<table><tr><td><div id="control1" style='padding-left: 5em'></div></td>
											<td><div id="monthcontrol" style='padding-left: 5em'></div></td></tr></table>
											<div id="chart_table" style='width: 1px; height: 1px;'
												hidden="true"></div>
										</div>
									</td>
								</tr>
							</table>
							<!--Div that will hold the loading circle-->
							<div id="wait"
								style="display: none; width: 50%; height: 50%; top: 50%; left: 50%; padding: 2px;">
								<br> <br> <br> <img src='static/images/482.GIF'
									width="35%" height="35%" /> <br> <br> <br> <b>Loading.......Please
									don't refresh page</b>
							</div>
							 <div id="chart_div7" style='width: 915px; height: 320px;'></div>
							<div id="subViewDiv" style="width: 1000px; height: 1500px;"></div>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>

	<!-- End of container -->
	<jsp:include page="../views/footer.jsp"></jsp:include>
</body>
</html>