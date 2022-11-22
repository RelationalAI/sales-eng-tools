package ai.relational.samples.spring.service;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.util.FileCopyUtils;

import com.relationalai.Client;
import com.relationalai.HttpError;
import com.relationalai.Relation;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Service
public class RelGraphService {
    
    final Logger LOGGER = LoggerFactory.getLogger(getClass());
    
    @Value("${rai.database}") String database;
    @Value("${rai.engine}") String engine;

    @Autowired
    Client raiClient;

    public Graph query(String dbName, String relFileName, Map<String, String> params) throws RaiException, ResourcesLoadException {
        ClassLoader cl = this.getClass().getClassLoader();
        InputStream inputStream = cl.getResourceAsStream("rel/" + relFileName + ".rel");
        try {
            byte[] bdata;
            bdata = FileCopyUtils.copyToByteArray(inputStream);
            String source = new String(bdata, StandardCharsets.UTF_8);
            if(params != null)
                for (Entry<String,String> param : params.entrySet()) {
                    source = source.replace("${"+param.getKey()+"}", param.getValue());
                }
            // LOGGER.info(source);
            return extractGraph(executeQuery(dbName, source));
        } catch (IOException e) {
            throw new ResourcesLoadException(relFileName + " REL file", e);
        }
    }

    public Graph query(String relFileName, Map<String, String> params) throws ResourcesLoadException, RaiException{
        return query(null, relFileName, params);
    }

    private Graph extractGraph(Relation[] relations){
        Object[][] edgeTable = relations[0].relKey.keys[0].equals(":edge") ? relations[0].columns : relations[1].columns;
        Object[][] nodeTable = relations[0].relKey.keys[0].equals(":node") ? relations[0].columns : relations[1].columns;
        List<Node> nodes = new ArrayList<Node>();
        List<Edge> edges = new ArrayList<Edge>();
        for (int i = 0; i < edgeTable[0].length; i++) {
            String sourceId = (String) edgeTable[0][i];
            String targetId = (String) edgeTable[1][i];
            String label = "";
            String fontColor = "";
            try{
                label = (String) edgeTable[2][i];
                fontColor = (String) edgeTable[3][i];
            } catch (Exception e) {
                LOGGER.info("No label or font color on edge");
            } 
            edges.add(new Edge(sourceId, targetId, label, fontColor));
        }
        for (int i = 0; i < nodeTable[0].length; i++) {            
            String nodeId = (String) nodeTable[0][i];
            String nodeLabel = (String) nodeTable[1][i];
            String nodeType = (String) nodeTable[2][i];
            nodes.add(new Node(nodeId, nodeLabel, nodeType));
        }
        return new Graph(nodes, edges);
    }

    public Relation[] executeQuery(String database, String source) throws RaiException{
        try {
            if(database == null || database.isEmpty())
                database = this.database;
            return raiClient.executeV1(database, engine, source, true).output;
        } catch (InterruptedException | IOException e) {
            LOGGER.error("Erro on executeQuery", e);
            throw new RaiException(e);
        } catch (HttpError e){
            LOGGER.error("HTTP error from REL", e);
            throw new RaiHttpException(e);
        }
    }

    @Data
    @EqualsAndHashCode
    @AllArgsConstructor
    public static class Node {
        String id;
        String label;
        String type;
    }

    @Data
    @AllArgsConstructor
    public static class Edge {
        String source;
        String target;
        String label;
        String fontcolor;
    }

    @Data
    @AllArgsConstructor
    public static class Graph {
        List<Node> nodes;
        List<Edge> edges;
    }
}
