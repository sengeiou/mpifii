<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ include file="../../common/splitPage.jsp" %> 
<form id="splitPage" class="form-horizontal" action="${cxt}/business/bigdata/userAnalys" method="POST">
	<div>
		<ul class="breadcrumb">
			<li><a href="javascript:void(0);" onclick="ajaxContent('/content');">主页</a><span class="divider">/</span></li>
			<li>
				<a href="#">大数据分析－精准用户分析</a>
			</li>
		</ul>
	</div>
	<div class="row-fluid sortable">
		<div class="box span12">
			<div class="box-header well" data-original-title>
				<h2><i class="icon-edit"></i>数据查询</h2>
				<div class="box-icon">
					<a href="#" class="btn btn-minimize btn-round"><i class="icon-chevron-down"></i></a>
				</div>
			</div>
			<div class="box-content" style="display: none;" >
				<fieldset>
				 	<div class="control-group">
					  		<label class="control-label" for="focusedInput">组织：</label>
							<div class="controls">
							  	<select id="select_org" multiple="multiple" >
									<c:forEach var="org" items="${orgList}">
										<option value="${org.id}">${org.name}</option>
									</c:forEach>
								</select>
								<input name="_query.org_id" id="qOrgId" value="${splitPage.queryParam.org_id}"  type="hidden" />
							</div>
							<label class="control-label" for="focusedInput">商铺：</label>
							<div class="controls">
							  	<select id="select_shop" multiple="multiple" >
									<option value="">--请先选择组织--</option>
								</select>
								<input name="_query.shop_id" id="qShopId" value="${splitPage.queryParam.shop_id}" type="hidden" />
							</div>
					</div>
				  	<div class="form-actions">
						<button type="button" class="btn btn-primary" onclick="splitPage(1);">查询</button>
						<button type="reset" class="btn">清除</button>
				  	</div>
				</fieldset>
			</div>
		</div><!--/span-->
	</div><!--/row-->
	<div class="row-fluid sortable">
		<div class="box span12">
			<div class="box-header well" data-original-title>
				<h2><i class="icon-user"></i>应用列表</h2>
			</div>
			<div class="box-content">
					<table class="table table-striped table-bordered bootstrap-datatable ">
					<thead>
						<tr>
							<th>组织名称</th>
							<th>商铺名称</th>
							<th>盒子名称</th>
							<th>SN</th>
							<th>状态</th>
							<th>类型</th>
							<th>认证时长（分钟）</th>
							<th>注册时间</th>
							<th>在线人数</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="device" items="${splitPage.page.list}" >
							<tr>
								<td class="center">${device.get("orgname")}</td>
								<td class="center">${device.get("shopname")}</td>
								<td class="center">${device.get("name")}</td>
								<td class="center">${device.get("router_sn")}</td>
								<td class="center">${device.get("online_num")>=0?'在线':'离线'}</td>
								<td class="center">${device.get("type")==1?'router':'AP'}</td>
								<td class="center">${device.get("time_out")}</td>
								<td class="center">${device.get("create_date")}</td>
								<td class="center">${device.get("online_num")>=0?device.get("online_num"):'0'}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
				<div id="splitPageDiv" class="pagination pagination-centered"></div>
			</div>
		</div>
		<!--/span-->
	</div>
	<!--/row-->
</form>
<script type="text/javascript">
$('#select_org').multiselect({
	enableFiltering: true,
	maxHeight: 150,
	onChange: function(){
		var checkId = $("#select_org").val();
		$("#qOrgId").attr("value",checkId);
		var url ="/business/shop/getShopByOrg?orgids="+checkId;
		$.ajax({
			type : 'POST',
			dataType : "json",
			url :encodeURI(encodeURI(cxt + url)),
			success : function(data) {
				$("#select_shop").multiselect('dataprovider',data);
			}
		});
	}
});
$('#select_shop').multiselect({
	enableFiltering: true,
	maxHeight: 150,
	onChange: function(){
		var checkId = $("#select_shop").val();
		$("#qShopId").attr("value",checkId);
	}
});
var dataXml = $("#dataXml").val();
var myChart = new FusionCharts('file/charts/Pie3D.swf', 'ad_chart_'+generRandomCharacters(10), "100%", 120);
myChart.setDataXML(dataXml);
myChart.render("chartdivvxml");
</script>
