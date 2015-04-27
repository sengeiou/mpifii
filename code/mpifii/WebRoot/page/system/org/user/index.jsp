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
<form id="splitPage" class="form-horizontal" action="${pageContext.request.contextPath}/business/org/user" method="POST">
	<div>
		<ul class="breadcrumb">
			<li><a href="javascript:void(0);" onclick="ajaxContent('/content');">主页</a><span class="divider">/</span></li>
			<li><a href="javascript:void(0);" onclick="ajaxContentReturn();">组织管理</a><span class="divider">/</span></li>
			<li>
				<a href="javascript:void(0);" onclick="ajaxContent('/business/org/user/index');">用户管理</a>
			</li>
		</ul>
	</div>

	<div class="row-fluid">
		<div class="box span12">
			<div class="box-header well" >
				<h2><i class="icon-user"></i> 用户列表</h2>
				<div class="box-icon">
					<a href="javascript:void(0);" class="btn btn-round" title="查找"><i class="icon-search"></i></a>
					<a href="javascript:void(0);" class="btn btn-round" title="添加用户" onclick="ajaxContent('/business/org/user/addOrModify',{orgId:'${splitPage.queryParam.org_id}'});"><i class="icon-plus-sign"></i></a>
				</div>
			</div>
			<div class="box-content">
				<div class="search-content"><!-- 这里必须取名为search-content，否则搜索框离开焦点的点击事件不会触发搜索框的隐藏 -->
					<fieldset><!-- 这下面搜索的字段要与数据库里表的字段对应 -->
					  	<div class="control-group">
							<label class="control-label" for="focusedInput">账号：</label>
							<div class="controls">
						  		<input class="input-xlarge focused" type="text" id="name_like" name="_query.name_like" value='${splitPage.queryParam.name_like}' maxlength="20" >
								<input type="hidden" name="_query.org_id"  value='${splitPage.queryParam.org_id}' >
							</div>
					  	</div>
					  
<!-- 					  	<div class="control-group"> -->
<!-- 							<label class="control-label">邮箱：</label> -->
<!-- 							<div class="controls"> -->
<%-- 						  		<input class="input-xlarge" type="text" id="email_like" name="_query.email_like" value='${splitPage.queryParam.email_like}' maxlength="40" > --%>
<!-- 							</div> -->
<!-- 					  	</div> -->
					
					  	<div class="form-actions">
							<button type="button" class="btn btn-primary" onclick="splitPage(1);">查询</button>
							<button type="reset" class="btn" onclick="clearform()">清除</button>
					  	</div>
					</fieldset>
				</div>
				<table class="table table-striped table-bordered bootstrap-datatable ">
					<thead>
						<tr>
							<th onclick="orderbyFun('name')">用户名</th>
<!-- 							<th>邮箱</th> -->
							<th>描述</th>
							<th>状态</th>
							<th>创建时间</th>
							<th width="300">操作</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="user" items="${splitPage.page.list}" >
							<tr>
								<td>${user.get("name")}</td>
<%-- 								<td class="center">${user.get("email")}</td> --%>
								<td class="center">${user.get("des")}</td>
								<td class="center">${user.get("status")==1?'正常':'冻结'}</td>
								<td class="center">${user.get("date")}</td>
								<td class="center" data-id='${user.get("id")}'>
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
		ajaxContent('/business/org/user/addOrModify',{id:id});
	});
	$("#splitPage .box-content tbody .icon-trash").parent().click(function(){
		var id = $(this).parent().data("id");
		myConfirm("确定要删除该数据？",function(){
			$.ajax({
				type: "POST",
				url: "business/org/user/delete",
				data: {id:id},
				success: function(data,status,xhr){
					ajaxContent("/business/org/user",{orgId:'${splitPage.queryParam.org_id}'});
				}
			});
		});
	});
	
	function clearform(){
		$("#name_like").val("");
		$("#email_like").val("");
	}
</script>