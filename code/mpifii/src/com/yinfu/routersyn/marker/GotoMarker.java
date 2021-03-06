package com.yinfu.routersyn.marker;

import java.io.IOException;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.yinfu.jbase.util.PropertyUtils;

public class GotoMarker extends BaseMarker{
	private static Logger logger = Logger.getLogger(GotoMarker.class);
	private Object shopId;
	
	public GotoMarker(Object shopId) throws IOException {
		super("goto",".html");
		this.shopId = shopId;
		setContentData();
	}
	public static boolean execute(Object shopId,String outputFolder){	
    	boolean success = false;
    	try {
    		success = new GotoMarker(shopId).createHtml(outputFolder);
		} catch (Exception e) {
			e.printStackTrace();
			success = false;
			logger.warn("生成goto.html异常！", e);
		}
    	return success;
	}
	
    private void setContentData(){
    	root.put("advs",getGotoAdvs());
    	root.put("title",getShopName());
    	root.put("gotoUrl",getGotoUrl());
    }
   
    private List<Record> getGotoAdvs(){
    	String defaultImg = "index/img/transition.png";
    	String authServerPath = PropertyUtils.getProperty("router.auth.url");
    	authServerPath = authServerPath.substring(0, authServerPath.lastIndexOf("/"));
    	StringBuffer sql = new StringBuffer();
    	sql.append("select ifnull(substring_index(batr.res_url,'/',-1),'') image,if(bac.link is null or bac.link='','#',concat('"+authServerPath+"','/portal/mb/adv?id=',bac.id)) link ");
    	sql.append("from bp_adv_shop bas join bp_adv_spaces basp on (bas.shop_id = ? and basp.adv_type='adv_start' and basp.id=bas.adv_spaces) ");
    	sql.append("join bp_adv_type bat on (basp.id=bat.adv_spaces) ");
    	sql.append("join bp_adv_content bac on (bas.content_id=bac.id) ");
    	sql.append("join bp_adv_type_res batr on (batr.adv_type_id=bat.id and batr.content_id=bac.id) ");
    	sql.append("order by bac.update_date desc ");
    	List<Record> advs = Db.find(sql.toString(),new Object[]{shopId});
    	Iterator<Record> ite = advs.iterator();
    	while(ite.hasNext()){
    		Record rec = ite.next();
    		String image = rec.getStr("image");
    		if(StringUtils.isNotBlank(image)){
    			image = "logo/"+image.substring(image.lastIndexOf("/")+1);
    		}else{
    			image = defaultImg;
    		}
    		rec.set("image", image);
    	}
    	if(advs.size() == 0){
    		advs.add(new Record().set("image", defaultImg).set("link", "#"));
    	}
    	return advs;
    }
    
    private String getShopName(){
    	String sql = "select ifnull(name,'') name from bp_shop where id=?";
    	Record rd = Db.findFirst(sql,new Object[]{shopId});
    	if(null != rd){
    		return rd.getStr("name");
    	}else{
    		return "尊敬的商户";
    	}
    }
    
    private String getGotoUrl(){
    	String url = "index.html";
    	StringBuffer sqlT = new StringBuffer();
    	sqlT.append("select ifnull(t.marker,'') marker ");
		sqlT.append("from bp_shop s join bp_shop_page sp on (s.id=? and s.id = sp.shop_id) ");
		sqlT.append("join bp_temp t on (sp.template_id=t.id)");
    	Record rec = Db.findFirst(sqlT.toString(), new Object[]{shopId});
    	if(null != rec && !"template1".equals(rec.get("marker"))){
    		String authServerPath = PropertyUtils.getProperty("router.auth.url");
        	authServerPath = authServerPath.substring(0, authServerPath.lastIndexOf("/"));
    		url = authServerPath+"/portal/mb/index";
    	}
    	return url;
    }
    
}
