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

<!-- Metro UI CSS JavaScript plugins -->
<script src="static/js/load-metro.js"></script>
<script type="text/javascript" src="static/js/jsapi.js"></script>
<script type="text/javascript">
	google.load('visualization', '1', {
		packages : [ 'corechart','controls','table','orgchart','motionchart'  ]
	});
</script>
<script type="text/javascript">
var yearPicker;
var monthPicker;
var companyPicker;
	$(document).ready(function() {
		drawVisualization();
		drawMotionChart();
	});

	$(document).ready(function() {
		var state1 = companyPicker.getState();
		var state2 = yearPicker.getState();
		var state3 = monthPicker.getState();
		makeAjaxCall(state1.selectedValues[0],state2.selectedValues[0],state3.selectedValues[0]);
	});
	function makeAjaxCall(tenant,year,month) {
		if (document.getElementById("Monthly").checked == true){
			$("#monthcontrol").hide();
		}else{
			$("#monthcontrol").show();
		}
		if (document.getElementById("Monthly").checked == true) {
			$
					.ajax({
						url : 'generateReportTenant1.do',
						method : "POST",
						data : "tenant=" + encodeURIComponent(tenant)
								+ "&year=" + year,
						success : function(response) {
							$("#subViewDiv").html(response);
						}
					});
		}
		if (document.getElementById("Weekly").checked == true) {
			$
					.ajax({
						url : 'generateReportTenant2.do',
						method : "POST",
						data : "tenant=" + encodeURIComponent(tenant)
								+ "&year=" + year + "&month=" + month,
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
			'state': {'selectedValues': ['2013']}
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
		// Define a category picker control for the Company Name column
		 companyPicker = new google.visualization.ControlWrapper({
			'controlType' : 'CategoryFilter',
			'containerId' : 'control2',
			'options' : {
				'filterColumnLabel' : 'Company Name',
				'ui' : {
					'labelStacking' : 'vertical',
					'allowNone' : false,
					'allowTyping' : false,
					'allowMultiple' : false
				}
			},
			'state': {'selectedValues': ['(株)倉崎鉄工所']}
		});
		// Define a table
		var table = new google.visualization.ChartWrapper({
			'chartType' : 'Table',
			'containerId' : 'chart_table',
			'options' : {
				'width' : '0px',
				'height' : '0px',
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
			var state1 = companyPicker.getState();
			var state2 = yearPicker.getState();
			var state3 = monthPicker.getState();
			makeAjaxCall(state1.selectedValues[0],state2.selectedValues[0],state3.selectedValues[0]);
				});
		google.visualization.events.addListener(monthPicker, 'statechange',
				function() {
			var state1 = companyPicker.getState();
			var state2 = yearPicker.getState();
			var state3 = monthPicker.getState();
			makeAjaxCall(state1.selectedValues[0],state2.selectedValues[0],state3.selectedValues[0]);
				});
		google.visualization.events.addListener(companyPicker, 'statechange',
				function() {
			var state1 = companyPicker.getState();
			var state2 = yearPicker.getState();
			var state3 = monthPicker.getState();
			makeAjaxCall(state1.selectedValues[0],state2.selectedValues[0],state3.selectedValues[0]);
				});
		// Create a dashboard
		var dashboard1 = new google.visualization.Dashboard(document
				.getElementById('dashboard1')).bind([yearPicker,monthPicker,companyPicker],[table]);
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
			var state1 = companyPicker.getState();
			var state2 = yearPicker.getState();
			makeAjaxCall(state1.selectedValues[0],
					state2.selectedValues[0]);
		});
	});

	function drawMotionChart() {
	var datafeed = '<c:out value="${logdatafeed}"/>';
		
		datafeed = datafeed.replace(/&#039;/g, '\'');
		datafeed = eval("(" + datafeed + ")");
	    //var data = google.visualization.arrayToDataTable(datafeed);
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
	      ['GOOGLE', new Date (1990,6,1),678,'DropBox', 'Remote Print']
	    ]);
	    var options = { iconKeySettings:[],
	    		"stateVersion":3,
	    		"time":"notime",
	    		"xAxisOption":"_NOTHING",
	    		"playDuration":15,
	    		"iconType":"BUBBLE",
	    		"sizeOption":"_NOTHING",
	    		"xZoomedDataMin":null,
	    		"xZoomedIn":true,
	    		showAdvancedPanel:false,
	    		"duration":{
	    			"multiplier":1,
	    			"timeUnit":"none"
	    			   },
	    			"yZoomedDataMin":null,
	    			"xLambda":1,
	    			"colorOption":"_NOTHING",
	    			"nonSelectedAlpha":0.4,
	    			"dimensions":{
	    				"iconDimensions":[]
	    			   },
	    			   "yZoomedIn":true,
	    			   "yAxisOption":"_NOTHING",
	    			   "yLambda":1,
	    			   "yZoomedDataMax":null,
	    			   "showTrails":true,
	    			   "xZoomedDataMax":null,
	    			    width:'75%',
						height:'80%',
							'view' : {
		    					'columns' : [ 2,{
		    				    type: 'date',
		    				    label: data.getColumnLabel(1),
		    				    calc: function (dt, rowIndex) {
		    				        var val = dt.getFormattedValue(rowIndex,0);
		    				        return (val != '' && val != null)?new Date(val): null;
		    				    }
		    				},3,4,5]
		    				}
			};
	    var chart = new google.visualization.MotionChart(document.getElementById('motion_chart_div'));
		//google.visualization.events.addListener(chart, 'error',  function (err) { google.visualization.errors.removeError(err.id); }); 
		chart.draw(data, options);
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
						<h2 id="__notice__">Summary of Individual Company service
							Report:</h2>
						<div class="example">
							<table>
								<tr>
									<td><label for="Report" class="control-label input-group">Report
											Type</label>
										<div class="input-control radio inline-block"
											data-role="input-control">
											<label class="inline-block"> <input type="radio"
												name="report" id="Monthly" checked /> <span class="check"></span>Monthly
											</label> <label class="inline-block"> <input type="radio"
												name="report" id="Weekly" /> <span class="check"></span>Weekly
											</label>
										</div></td>
									<td>
										<div id="dashboard1">
											<table>
												<tr>
													<td><div id="control1" style='padding-left: 5em'></div></td>
													<td><div id="monthcontrol" style='padding-left: 5em'></div></td>
													<td>
														<div id="control2" style='padding-left: 5em'></div>
													</td>
												</tr>
											</table>
											<div id="chart_table" style='width: 1px; height: 1px;' hidden="true"></div>
										</div>
									</td>
								</tr>
							</table>
							<!--Div that will hold the loading circle-->
							<div id="wait"
								style="display: none; width: 50%; height: 50%; top: 50%; left: 50%; padding: 2px;">
								<br> <br> <br> <img src='static/images/482.GIF'
									width="35%" height="35%" /><br> <br> <br> <b>Loading.......Please
									don't refresh page</b>
							</div>
							<div id="motion_chart_div" style='width: 915px; height: 320px;'></div>
							<div id="subViewDiv" style="width: 1000px; height: 800px;"></div>
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