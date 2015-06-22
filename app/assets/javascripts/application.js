// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require turbolinks
//= require select2.full
//= require moment
//= require daterangepicker
//= require underscore

//= require highstock
//= require highcharts-more
//= require highcharts-solid-gauge
//= require highcharts-no-data-to-display
//= require highcharts-3d
//= require highcharts-drilldown

params = {};
$(document).ready(function(){
		_reports = {};
		_reports.fetch = function(){
			params.user = $('.user').val();
			params.branch = $('.branch').val();
			params.day = $('.day').val();
			params.date = $('.daterangepicker').val();
			params.type = $('input[name="inlineRadioOptionsBudget"]:checked').val();
			var xmlRequest = $.ajax({
				url: 'get_data',
				type:"GET",
				dataType: "json",
				data: params
			});
			return xmlRequest;
		};
		_reports.report1 = function(){
			var _i = {};
			var options = {};
			var start_date, end_date;
			_i.init_date = function(){
				if(params.type=="daily"){
					start_date = moment().subtract("months", 3).format("DD/MM/YYYY");
					end_date = moment().format("DD/MM/YYYY");
					options = {
						startDate: start_date,
						endDate: end_date,
						ranges: {
							'Today': [moment(), moment()],
							'Yesterday': [moment().subtract('days', 1), moment().subtract('days', 1)],
							'Last 7 Days': [moment().subtract('days', 6), moment()],
							'Last 30 Days': [moment().subtract('days', 29), moment()],
							'This Month': [moment().startOf('month'), moment().endOf('month')],
							'Last Month': [moment().subtract('month', 1).startOf('month'), moment().subtract('month', 1).endOf('month')]
						}
					}
					_i.xAxis = {range: 30 * 24 * 3600 * 1000};
				}else{
					offset = Math.abs(new Date().getTimezoneOffset()*60000);
					_i.xAxis = {range: 12 * 3600 * 1000, min: new Date().setDate(new Date().getDate() - 1)+offset, max: new Date().getTime()+offset};
					start_date = moment().subtract("days", 2).format("DD/MM/YYYY");
					end_date = moment().format("DD/MM/YYYY");
					options = {
						startDate: start_date,
						endDate: end_date,
						dateLimit: {days: 2},
						ranges: {
							'Today': [moment(), moment()],
							'Yesterday': [moment().subtract('days', 1), moment().subtract('days', 1)],
						}
					}
				}
				options.format = 'DD/MM/YYYY';
				options.opens = "left";
				$(_reports.div_id + ' .datepicker-container input[name="daterange"]').replaceWith('<input readonly="readonly" type="text" name="daterange" value="'+start_date+' - '+end_date+'" class="form-control report-daterange" placeholder="Duration">');
				$(_reports.div_id + ' .datepicker-container input[name="daterange"]').daterangepicker(options, function(start, end){
					_reports[_reports.type]();
				});
			};
			_i.process = function(){
				var series = {total_commits: []};
				_.each(_i.data, function(values, timestamp){
					timestamp = parseInt(timestamp)
					series.total_commits.push([timestamp, values.commits]);
				});
				_i.data = series;
			};
			_i.generate = function(){
				Highcharts.setOptions({
					global: {
						useUTC: true
					},
					chart: {
				        style: {
				            fontFamily: '"Ubuntu",Helvetica,Arial,sans-serif'
				        }
				    }
				});
				_i.render_chart();
			};
			_i.render_chart = function(){
				_reports.fetch().done(function(one, two, three){
					try{
						_i.data = one;
						_i.process();
						_i.chart = $('.report').highcharts('StockChart', {
							chart: {
								alignTicks: false
							},
							credits: {
								enabled: false
				  			},
							rangeSelector: {
								inputEnabled: false,
							},
							title: false,
							legend: {
								enabled: true,
								itemDistance: 30,
								itemMarginTop: 15,
								padding: 20,
							},
							tooltip: {
								formatter: function(){
									var output = '';
									if(params.type=="daily"){
										output = '<b>' + Highcharts.dateFormat('%A, %b %e, %Y', this.x) + '</b>';
									}else{
										output = '<b>' + Highcharts.dateFormat('%I%P %b %e (%a), %Y', this.x) + '</b>';
									}
									_.each(this.points, function(point){
											output += '<br/> <span style="color:'+point.series.color+'">'+point.series.name +'</span> : '+point.y;
									});
									return output;
								},
								shared: true
							},
							yAxis: {
								title: false
							},
							xAxis: _i.xAxis,
							series: [{
								type: 'area',
								name: 'Commits',
								data: _i.data.total_commits,
								color: "#9bc6ef",
								stacking: "normal"
							}]
						}, function (chart) { // on complete
				   		});
					}catch(e){
						console.log(e);
					}
				});
			}
			_i.generate();
		};
		$('.user').select2({
			multiple: false,
			minimumInputLength: 3,
			cache: true,
			ajax: {
				url: "data_provider",
				dataType: "json",
				delay: 250,
				data: function (search, page) {
					hash = {};
					hash["q"] = search.term;
					return hash;
				},
				processResults: function (data, page) {
					return {results: data};
				}
			}
		});
		$('.branch').select2({
			multiple: false
		});
		$('.day').select2({
			multiple: false
		});
		var date_options = {
			format: 'DD/MM/YYYY',
			startDate: moment().subtract("days", 30).format("DD/MM/YYYY"),
			endDate: moment().format("DD/MM/YYYY"),
			ranges: {
				'Today': [moment(), moment()],
				'Yesterday': [moment().subtract('days', 1), moment().subtract('days', 1)],
				'Last 7 Days': [moment().subtract('days', 6), moment()],
				'Last 30 Days': [moment().subtract('days', 29), moment()],
				'This Month': [moment().startOf('month'), moment().endOf('month')],
				'Last Month': [moment().subtract('month', 1).startOf('month'), moment().subtract('month', 1).endOf('month')]
			},
			opens: "left"
		}
		$('.daterangepicker').daterangepicker(date_options);
		$('.generate').click(function(e){
			_reports.report1();
		});
	});