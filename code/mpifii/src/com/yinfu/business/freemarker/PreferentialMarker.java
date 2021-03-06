package com.yinfu.business.freemarker;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.jfinal.kit.PathKit;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.yinfu.jbase.util.PropertyUtils;

import freemarker.template.Configuration;
import freemarker.template.Template;

public class PreferentialMarker {

    private Configuration cfg;
    private static PreferentialMarker m_instance = null;
    private Object shopId = "0";
    private boolean bool = false;
    private String rootPath = PathKit.getWebRootPath()+File.separator+"file"+File.separator+"freemarker"+File.separator;
    private String savePath = rootPath+"html"+File.separator;
    
    
	public PreferentialMarker() {
		try {
        	cfg = new Configuration();
            cfg.setDefaultEncoding("UTF-8");
			cfg.setDirectoryForTemplateLoading(new File(rootPath+File.separator+"ftl"));
		} catch (IOException e) {
		}
	}
	
    public synchronized static PreferentialMarker getInstance() {
		if (m_instance == null) {
			m_instance = new PreferentialMarker();
		}
		return m_instance;
	}
    
    /**
     * 根据shopId创建html
     * @param shopId(0:全部)
     * @return
     */
    public boolean createHtml(Object shopId){
		try {
			this.shopId = shopId;
			Map root = new HashMap();
			root.put("preferentiallist", getPreferential());

			Template t = cfg.getTemplate("preferential.ftl");
			String dir = savePath + shopId + File.separator + "mb"+ File.separator + "mall";
			File htmlFile = new File(dir);
			htmlFile.mkdirs();
			Writer out = new BufferedWriter(new OutputStreamWriter(
					new FileOutputStream(dir + File.separator + "preferential.html"),
					"UTF-8"));
			t.process(root, out);
			out.flush();
			out.close();
			bool = true;
			System.out.println("生成完毕");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return bool;
    }
   
    
    private List<Record> getPreferential(){
    	String imgDir = PropertyUtils.getProperty("downdir.mallImg", "/storageroot/Data/mb/mall/images");
    	String[] img = imgDir.split("/");
    	imgDir = img[img.length-1];
    	
    	StringBuffer sql = new StringBuffer("select ");
    	sql.append("id,title,txt,");
    	sql.append("concat(?,'/',ifnull(reverse(left(reverse(img),locate('/',reverse(img))-1)),'')) as img ");
    	sql.append("from bp_preferential ");
    	sql.append("where shop_id=? and delete_date is null");
    	List<Record> list = Db.find(sql.toString(), new Object[]{imgDir,shopId});
    	return list;
    }
    
    
    public static void main(String[] args)throws Exception{
    	
    }
}
