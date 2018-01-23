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
		packages : [ 'corechart', 'controls' ]
	});
</script>
<script type="text/javascript">
	// Set a callback to run when the Google Visualization API is loaded.
    google.setOnLoadCallback(drawVisualization);

	function drawVisualization() {
		var datafeed = '<c:out value="${datafeed}"/>';
		datafeed = datafeed.replace(/&#039;/g, '\'');
		datafeed = eval("(" + datafeed + ")");
		var data = google.visualization.arrayToDataTable(datafeed);

		var slider = new google.visualization.ControlWrapper({
			'controlType' : 'DateRangeFilter',
			'containerId' : 'control1',
			'options' : {
				'filterColumnLabel' : 'Date',
				'ui' : {
					'labelStacking' : 'vertical'
				}
			}
		});
		// Define a category picker control for the Company Name column
		var companyPicker = new google.visualization.ControlWrapper({
			'controlType' : 'CategoryFilter',
			'containerId' : 'control2',
			'options' : {
				'filterColumnLabel' : 'Company Name',
				'ui' : {
					'labelStacking' : 'vertical',
					'allowTyping' : false,
					'allowMultiple' : true
				}
			}
		});
		// Define a category picker control for the Functionality column
		var categoryPicker = new google.visualization.ControlWrapper({
			'controlType' : 'CategoryFilter',
			'containerId' : 'control3',
			'options' : {
				'filterColumnLabel' : 'Functionality',
				'ui' : {
					'labelStacking' : 'vertical',
					'allowTyping' : false,
					'allowMultiple' : true
				}
			}
		});
		// Define a table
		var table = new google.visualization.ChartWrapper({
			'chartType' : 'Table',
			'containerId' : 'chart2',
			'options' : {
				'width' : '750px',
				'page' : 'enable',
				'pageSize' : 15,
				'pagingSymbols' : {
					prev : 'prev',
					next : 'next'
				},
				'pagingButtonsConfiguration' : 'auto'
			}
		});
		// Create a dashboard
		new google.visualization.Dashboard(document.getElementById('dashboard'))
				.bind([ slider, companyPicker, categoryPicker ], [ table ])
				.draw(data);
	}

	$(document).ready(function() {
		$(document).ajaxStart(function() {
			$("#wait").css("display", "block");
		});
		$(document).ajaxComplete(function() {
			$("#wait").css("display", "none");
		});
	});
</script>
<title>Data Automation & Visualization Dashboard 2.0</title>
</head>
<body class="metro">
	<jsp:include page="../views/header.jsp"></jsp:include>
	<div class="container" align="center">
		<div>
			<table>
				<tr>
					<td class="span3"
						style='vertical-align: top; background-color: #3D3D3D'><jsp:include
							page="../views/sidebar.jsp"></jsp:include></td>
					<td>
						<h2 id="__notice__">Summary of Raw Usage Data:</h2>
						<div class="example">
							<table>
								<tr>
									<td>
										<!--Div that will hold the loading circle-->
										<div id="wait"
											style="display: none; width: 50%; height: 50%; top: 50%; left: 50%; padding: 2px;">
											<br> <br> <br> <img
												src='static/images/482.GIF' width="35%" height="35%" /><br>
											<br> <br> <b>Loading.......Please don't refresh
												page</b>
										</div> <!--Div that will hold the dashboard-->

										<div id="dashboard">
											<table>
												<tr>
													<td>
														<div id="control1"></div>
													</td>
													<td><a href="getCSV.do?output=csv"><button
																class="image-button primary">
																Download <img src="static/images/download-32.png"
																	class="bg-cobalt">
															</button></a></td>
												</tr>
												<tr>
													<td>
														<div id="control2"></div>
														<div id="control3"></div>
													</td>
												</tr>
												<tr>
													<td><div style="width: 875px; height: 400px;"
															id="chart2"></div></td>

												</tr>
											</table>
										</div>
									</td>
								</tr>
							</table>
						</div>
					</td>
				</tr>
			</table>
		</div>
		<!-- End of container -->
	</div>
	<jsp:include page="../views/footer.jsp"></jsp:include>
</body>
</html>