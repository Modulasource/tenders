
/*
* Studio Matamore - France 2007, tous droits réservés
* Contact : studio@matamore.com - http://www.matamore.com
*/

package org.coin.fr.bean;

import org.coin.db.*;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import java.sql.*;
import java.util.Vector;

public class CorrespondantOrganisation extends CoinDatabaseAbstractBean {

    private static final long serialVersionUID = 1L;

    protected long lIdTypeObjet;
    protected long lIdAdresse;
    protected long lIdOrganisation;
    protected long lIdReferenceObjet;
    protected String sStatuts;

    public void setPreparedStatement(PreparedStatement ps) throws SQLException {
        int i = 0;
        ps.setLong(++i, this.lIdTypeObjet);
        ps.setLong(++i, this.lIdAdresse);
        ps.setLong(++i, this.lIdOrganisation);
        ps.setLong(++i, this.lIdReferenceObjet);
        ps.setString(++i, this.sStatuts);
    }

    public void setFromResultSet(ResultSet rs) throws SQLException {
        int i = 0;
        this.lIdTypeObjet = rs.getLong(++i);
        this.lIdAdresse = rs.getLong(++i);
        this.lIdOrganisation = rs.getLong(++i);
        this.lIdReferenceObjet = rs.getLong(++i);
        this.sStatuts = rs.getString(++i);
    }

    public CorrespondantOrganisation() {
        init();
    }

    public CorrespondantOrganisation(long lId) {
        init();
        this.lId = lId;
    }

    public void init() {
        super.TABLE_NAME = "correspondant_organisation";
        super.FIELD_ID_NAME = "id_"+ super.TABLE_NAME;
        super.SELECT_FIELDS_NAME =
                " id_type_objet,"
                + " id_adresse,"
                + " id_organisation,"
                + " id_reference_objet,"
                + " statuts";

        super.SELECT_FIELDS_NAME_SIZE = super.SELECT_FIELDS_NAME.split(",").length;

        super.lId = 0;
        this.lIdTypeObjet = 0;
        this.lIdAdresse = 0;
        this.lIdOrganisation = 0;
        this.lIdReferenceObjet = 0;
        this.sStatuts = "";
    }

    public static CorrespondantOrganisation getCorrespondantOrganisation(long lId) throws Exception {
        CorrespondantOrganisation item = new CorrespondantOrganisation(lId);
        item.load();
        return item;
    }

    public void setFromForm(HttpServletRequest request, String sFormPrefix) {
        try {
            this.lIdTypeObjet = Long.parseLong(request.getParameter(sFormPrefix + "lIdTypeObjet"));
        } catch(Exception e){}
        try {
            this.lIdAdresse = Long.parseLong(request.getParameter(sFormPrefix + "lIdAdresse"));
        } catch(Exception e){}
        try {
            this.lIdOrganisation = Long.parseLong(request.getParameter(sFormPrefix + "lIdOrganisation"));
        } catch(Exception e){}
        try {
            this.lIdReferenceObjet = Long.parseLong(request.getParameter(sFormPrefix + "lIdReferenceObjet"));
        } catch(Exception e){}
    }

    public static Vector<CorrespondantOrganisation> getAllWithSqlQueryStatic(String sSQLQuery)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        CorrespondantOrganisation item = new CorrespondantOrganisation();
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<CorrespondantOrganisation> getAllStatic()
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        CorrespondantOrganisation item = new CorrespondantOrganisation();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item);
    }

    public static Vector<CorrespondantOrganisation> getAllStatic(Connection conn)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        CorrespondantOrganisation item = new CorrespondantOrganisation();
        String sSQLQuery
        = "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
        + " FROM " + item.TABLE_NAME;
        return getAllWithSqlQuery(sSQLQuery, item, conn);
    }

    @SuppressWarnings("unchecked")
    public static Vector<CorrespondantOrganisation> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause)
    throws InstantiationException, IllegalAccessException, NamingException, SQLException {
        CorrespondantOrganisation item = new CorrespondantOrganisation();
        return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);
    }

    @SuppressWarnings("unchecked")
    public <T> Vector<T> getAllWithSqlQuery(String sSqlquery) throws NamingException, SQLException, InstantiationException, IllegalAccessException {
        return (Vector<T>) getAllWithSqlQueryStatic(sSqlquery);
    }

    @Override
    public String getName() {
        return "correspondant_organisation_"+this.lId;
    }

    public long getIdTypeObjet() {return this.lIdTypeObjet;}
    public void setIdTypeObjet(long lIdTypeObjet) {this.lIdTypeObjet = lIdTypeObjet;}

    public long getIdAdresse() {return this.lIdAdresse;}
    public void setIdAdresse(long lIdAdresse) {this.lIdAdresse = lIdAdresse;}

    public long getIdOrganisation() {return this.lIdOrganisation;}
    public void setIdOrganisation(long lIdOrganisation) {this.lIdOrganisation = lIdOrganisation;}

    public long getIdReferenceObjet() {return this.lIdReferenceObjet;}
    public void setIdReferenceObjet(long lIdReferenceObjet) {this.lIdReferenceObjet = lIdReferenceObjet;}

    public String getStatuts() {return this.sStatuts;}
    public void setStatuts(String sStatuts) {this.sStatuts = sStatuts;}

    public JSONObject toJSONObject() throws JSONException {
        JSONObject item = new JSONObject();
        item.put("lId", this.lId);
        item.put("lIdTypeObjet", this.lIdTypeObjet);
        item.put("lIdAdresse", this.lIdAdresse);
        item.put("lIdOrganisation", this.lIdOrganisation);
        item.put("lIdReferenceObjet", this.lIdReferenceObjet);
        item.put("sStatuts", this.sStatuts);
        return item;
    }

    public static JSONObject getJSONObject(long lId) throws Exception {
        CorrespondantOrganisation item = getCorrespondantOrganisation(lId);
        JSONObject data = item.toJSONObject();
        return data;
    }

    public static JSONArray getJSONArray() throws Exception {
        JSONArray items = new JSONArray();
        for (CorrespondantOrganisation item:getAllStatic()) items.put(item.toJSONObject());
        return items;
    }

    public void setFromJSONObject(JSONObject item) throws Exception {
        try {
            this.lIdTypeObjet = item.getLong("lIdTypeObjet");
        } catch(Exception e){}
        try {
            this.lIdAdresse = item.getLong("lIdAdresse");
        } catch(Exception e){}
        try {
            this.lIdOrganisation = item.getLong("lIdOrganisation");
        } catch(Exception e){}
        try {
            this.lIdReferenceObjet = item.getLong("lIdReferenceObjet");
        } catch(Exception e){}
        try {
            this.sStatuts = item.getString("sStatuts");
        } catch(Exception e){}
    }

    public static boolean storeFromJSONString(String jsonStringData) throws Exception {
        return storeFromJSONObject(new JSONObject(jsonStringData));
    }

    public static boolean storeFromJSONObject(JSONObject data) throws Exception {
        try {
            CorrespondantOrganisation item = null;
            try{
                item = CorrespondantOrganisation.getCorrespondantOrganisation(data.getLong("lId"));
            } catch(Exception e){
                item = new CorrespondantOrganisation();
                item.create();
            }
            item.setFromJSONObject(data);
            item.store();
            return true;
        } catch(Exception e){
            return false;
        }
    }

}
