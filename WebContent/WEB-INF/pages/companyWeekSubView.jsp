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
<script src="static/js/jquery/jquery.min.js"></script>
<script src="static/js/jquery/jquery.widget.min.js"></script>
<script type="text/javascript" src="static/js/jsapi.js"></script>

<!-- Metro UI CSS JavaScript plugins -->
<script src="static/js/load-metro.js"></script>

<script type="text/javascript">
google.load('visualization', '1', {packages: ['corechart','controls','table','orgchart']});  
</script>
<script type="text/javascript">
$(document).ready(function() {drawVisualization2();});
var dashboard;
var chart1;
function barMouseOver(e) {
	chart1.setSelection([{'row': null, 'column': null}]);
  }
function drawVisualization2() {
	var datafeed = '<c:out value="${weekdatafeed}"/>';
	datafeed = datafeed.replace(/&#039;/g, '\'');
	datafeed = eval("(" + datafeed + ")");
	dashboard = new google.visualization.Dashboard(document.getElementById('dashboard2'));

	debugger;

	var control = new google.visualization.ControlWrapper({
		'controlType' : 'ChartRangeFilter',
		'containerId' : 'control3',
		'options' : {
			// Filter by the date axis.
			'filterColumnIndex' : 0,
			'ui' : {
				'chartType' : 'LineChart',
				'chartOptions' : {
					'chartArea' : {
						'width' : '90%'
					},
					'hAxis' : {
						'baselineColor' : 'none',
						'format':"EE"
					}
				},
				// Display a single series that shows the closing value of the stock.
				// Thus, this view has two columns: the date (axis) and the stock value (line series).
				'chartView' : {
					'columns' : [ 0, 8 ]
				},
				// 1 day in milliseconds = 24 * 60 * 60 * 1000 = 86,400,000
				'minRangeSize' : 604800000,
				'maxRangeSize' : 604800000
			}
		},
		// Initial range: 2012-02-09 to 2012-03-20.
		'state' : {
			'range' : {
				'start' : new Date(2011, 12, 1),
				'end' : new Date(2014, 12, 1)
			}
		}
	});

	debugger;
	chart1 = new google.visualization.ChartWrapper({
		'chartType' : 'LineChart',
		'containerId' : 'chart1',
		'options' : {
			title : 'Trend line for each service',
			// Use the same chart area width as the control for axis alignment.
			'chartArea' : {
				'height' : '80%',
				'width' : '70%'
			},
			'hAxis' : {
				'slantedText' : true
			},
			'vAxis' : {
				'logScale': true
			},
		    pointSize: 10,
			series: {
			        0: { pointShape: 'square' },
	                1: { pointShape: 'square' },
	                2: { pointShape: 'square' },
	                3: { pointShape: 'square' },
	                4: { pointShape: 'square' },
	                5: { pointShape: 'square' }
	            },
			'legend' : {
				'position' : 'right'
			}
		},
		// Convert the first column from 'date' to 'string'.
		'view' : {
			'columns' : [ {
				'calc' : function(dataTable, rowIndex) {
					return dataTable.getFormattedValue(rowIndex, 0);
				},
				'type' : 'string'
			},3,4,5,6,7,8 ]
		}
	});
	var chart2 = new google.visualization.ChartWrapper({
		'chartType' : 'ColumnChart',
		'containerId' : 'chart2',
		'options' : {
		    'tooltip': { 'isHtml': true },
			'isStacked' : true,
			title : 'Application Service Usage Breakup',
			// Use the same chart area width as the control for axis alignment.
			'chartArea' : {
				'height' : '80%',
				'width' : '70%'
			},
			'hAxis' : {
				'slantedText' : true
			},
			'vAxis' : {
				'logScale': true
			},
			'legend' : {
				'position' : 'right'
			}
		},
		// Convert the first column from 'date' to 'string'.
		'view' : {
			'columns' : [ {
				'calc' : function(dataTable, rowIndex) {
					return dataTable.getFormattedValue(rowIndex, 0);
				},
				'type' : 'string'
			},3,4,5,6,7,8]
		}
	});
	
	debugger;
	
	var data = google.visualization.arrayToDataTable(datafeed);
	dashboard.bind([control],[chart1, chart2]);
	google.visualization.events.addListener(dashboard, 'error', function (dashboard) { google.visualization.errors.removeAll(document.getElementById("dashboard2")); });
	google.visualization.events.addListener(control, 'error',  function (err) { google.visualization.errors.removeError(err.id); }); 
	dashboard.draw(data);
    // Add our over/out handlers.
	  //google.visualization.events.addListener(chart1, 'onmouseover', barMouseOver);
	  google.visualization.events.addListener(chart1, 'onmouseover', function () {
		    $('#chart1').mouseover(function (e) {
		    	chart1.setSelection([{'row': null, 'column': null}]);
		    });
		});
}
</script>
</head>
<body>
 <h2>Weekly Report</h2> 
 ${noDataErrorMessage}
	<div id="dashboard2">
		<br> <br>
		<div id="chart1" style='width: 915px; height: 200px;'></div>
		<br> <br>
		<br> <br>
		<div id="chart2" style='width: 915px; height: 200px;'></div>
		<br> <br>
		<br> <br>
		<br> <br>
		<div id="control3" style='width: 915px; height: 50px;'></div>
	</div>

</body>
</html>