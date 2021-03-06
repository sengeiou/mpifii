<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags"%>
<%@ include file="../../../common/splitPage.jsp" %> 

<style type="text/css">
	#splitPage .search-content{
/* 		display: none; */
		position: absolute;
		width: 98%;
		background-color: white;
		border: 1px solid #DDDDDD;
		-webkit-box-shadow: #666 0px 0px 10px;
		-moz-box-shadow: #666 0px 0px 10px;
		box-shadow: #666 0px 0px 10px;
		padding-top: 20px;
/* 		border-right: 1px solid #DDDDDD; */
/* 		border-bottom: 1px solid #DDDDDD; */
	}
	#splitPage .box-content{
		position: relative;
	}
	#splitPage .form-actions{
		margin-top: 0px;
		margin-bottom: 0px;
	}
</style>
<form id="splitPage" class="form-horizontal" action="${pageContext.request.contextPath}/business/org/device" method="POST">
	<div>
		<ul class="breadcrumb">
			<li><a href="javascript:void(0);" onclick="ajaxContent('/content');">主页</a><span class="divider">/</span></li>
			<li><a href="javascript:void(0);" onclick="ajaxContent('/business/org');">组织管理</a><span class="divider">/</span></li>
			<li><a href="javascript:void(0);" onclick="ajaxContentReturn();">商铺管理</a><span class="divider">/</span></li>
			<li>
				<a href="javascript:void(0);" onclick="">盒子管理</a>
			</li>
		</ul>
	</div>

	<div class="row-fluid">
		<div class="box span12">
			<div class="box-header well" >
				<h2><i class="icon-user"></i>盒子列表</h2>
				<div class="box-icon">
					<a href="javascript:void(0);" class="btn btn-round" title="查找"><i class="icon-search"></i></a>
					<a href="javascript:void(0);" class="btn btn-round" title="添加盒子" onclick="ajaxContent('/business/org/device/addOrModify',{shopId:'${splitPage.queryParam.shop_id}'});"><i class="icon-plus-sign"></i></a>
				</div>
			</div>
			<div class="box-content">
				<div class="search-content"><!-- 这里必须取名为search-content，否则搜索框离开焦点的点击事件不会触发搜索框的隐藏 -->
					<fieldset><!-- 这下面搜索的字段要与数据库里表的字段对应 -->
					  	<div class="control-group">
							<label class="control-label" for="focusedInput">SN</label>
							<div class="controls">
						  		<input class="input-xlarge focused" type="text" name="_query.router_sn_like" id="sn_like" value='${splitPage.queryParam.router_sn_like}' maxlength="20" >
						  		<input type="hidden" name="_query.shop_id"  value='${splitPage.queryParam.shop_id}' >
							</div>
					  	</div>
					  	
					  	<div class="control-group">
							<label class="control-label">类型</label>
							<div class="controls">
								<select name="_query.type" id="type" class="input-xlarge">
									<option value="">全部</option>
									<option value="1" <c:if test="${splitPage.queryParam.type == '1'}">selected="selected"</c:if>>route</option>
									<option value="2" <c:if test="${splitPage.queryParam.type == '2'}">selected="selected"</c:if>>AP</option>
								</select>
							</div>
						</div>
						
					  	<div class="form-actions">
							<button type="button" class="btn btn-primary" onclick="splitPage(1);">查询</button>
							<button type="reset" class="btn" onclick="clearform()">清除</button>
					  	</div>
					</fieldset>
				</div>
				<table class="table table-striped table-bordered bootstrap-datatable ">
					<thead>
						<tr>
							<th>SN</th>
							<th>类型</th>
							<th>商铺</th>
							<th>注册时间</th>
							<th width="180">操作</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="device" items="${splitPage.page.list}" >
							<tr>
								<td class="center">${device.get("router_sn")}</td>
								<td class="center">${device.get("type")==1?'route':'AP'}</td>
								<td class="center">${device.get("shop_name")}</td>
								<td class="center">${device.get("create_date")}</td>
								<td class="center" data-id='${device.get("id")}'>
									<a class="btn btn-info" href="javascript:void(0);"> <i class="icon-edit icon-white"></i> 编辑</a>
									<a class="btn btn-danger" href="javascript:void(0);"> <i class="icon-trash icon-white"></i> 删除</a>
								</td>
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
	$("#splitPage .search-content").hide();
	$("#splitPage .search-content").click(function(){
		return false;//禁止该事件冒泡
	});
	$("#splitPage .box-header .box-icon .icon-search").parent().click(function(){
		var obj = $("#splitPage .search-content");
		if(obj.is(':hidden')){
			$("#splitPage .search-content").slideDown();
			return false;//禁止该事件冒泡
		}
	});
	$("#splitPage .box-content tbody .icon-edit").parent().click(function(){
		var id = $(this).parent().data("id");
		ajaxContent('/business/org/device/addOrModify',{id:id});
	});
	$("#splitPage .box-content tbody .icon-trash").parent().click(function(){
		var id = $(this).parent().data("id");
		myConfirm("确定要删除该数据？",function(){
			$.ajax({
				type: "POST",
				url: "business/org/device/delete",
				data: {id:id},
				success: function(data,status,xhr){
					ajaxContent('/business/org/device',{shopId:'${splitPage.queryParam.shop_id}'});
				}
			});
		});
	});
	
	function clearform(){
		$("#sn_like").val("");
		$("#type").val("");
	}
</script>