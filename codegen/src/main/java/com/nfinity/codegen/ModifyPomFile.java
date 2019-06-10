package com.nfinity.codegen;
import java.io.File;
import java.io.IOException;
import java.lang.reflect.Field;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class ModifyPomFile {

	public static void update(String path) {
		List<Dependency> dependencies = new ArrayList<Dependency>();

		Dependency javersSql = new Dependency("org.javers", "javers-spring-boot-starter-sql", "3.10.1");
		Dependency javersCore = new Dependency("org.javers","javers-core","3.10.2");
		Dependency mapstruct = new Dependency("org.mapstruct", "mapstruct", "1.2.0.Final");
		Dependency querydsljpa = new Dependency("com.querydsl", "querydsl-jpa", "4.2.1");
		Dependency querydslapt= new Dependency("com.querydsl", "querydsl-apt", "4.2.1");
		Dependency apache_commons = new Dependency("org.apache.commons", "commons-lang3", "3.8.1");
		Dependency postgres = new Dependency("org.postgresql","postgresql","42.2.5");

		dependencies.add(javersSql);
		dependencies.add(javersCore);
		dependencies.add(mapstruct);
		dependencies.add(querydsljpa);
		dependencies.add(querydslapt);
		dependencies.add(apache_commons);
		dependencies.add(postgres);

		ModifyPomFile.addDependenciesAndPluginsToPom(path,dependencies);

	}
	public static void addDependenciesAndPluginsToPom(String path, List<Dependency> dependencies) {

		try {
			DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
			Document doc = docBuilder.parse(path);

			// Get the staff element by tag name directly
			Node dependenciesNode = doc.getElementsByTagName("dependencies").item(0);
			for(Dependency dependency:dependencies){

				Element dependencyNode = doc.createElement("dependency");
				String groupId = dependency.getGroupId();
				String artifactId = dependency.getArtifactId();
				String version = dependency.getVersion();

				if(!groupId.isEmpty()){
					Element elem = doc.createElement("groupId");
					elem.appendChild(doc.createTextNode(groupId));
					dependencyNode.appendChild(elem);
					dependenciesNode.appendChild(dependencyNode);
				}

				if(!artifactId.isEmpty()){
					Element elem = doc.createElement("artifactId");
					elem.appendChild(doc.createTextNode(artifactId));
					dependencyNode.appendChild(elem);
					dependenciesNode.appendChild(dependencyNode);
				}

				if(!groupId.isEmpty()){
					Element elem = doc.createElement("version");
					elem.appendChild(doc.createTextNode(version));
					dependencyNode.appendChild(elem);
					dependenciesNode.appendChild(dependencyNode);
				}

			} 

			Node pluginsNode = doc.getElementsByTagName("plugins").item(0);
			List<Element> pluginList = getPlugins(doc);
			for(Element plugin:pluginList) {
				pluginsNode.appendChild(plugin);
			}

			removeScopeTagFromTestDependency(dependenciesNode);
			removeSpringBootMavenPlugin(pluginsNode);
			// write the content into xml file
			TransformerFactory transformerFactory = TransformerFactory.newInstance();
			Transformer transformer = transformerFactory.newTransformer();
			transformer.setOutputProperty(OutputKeys.INDENT, "yes");
			transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "4");
			DOMSource source = new DOMSource(doc);
			StreamResult result = new StreamResult(new File(path));
			transformer.transform(source, result);

			System.out.println("Done");

		} catch (ParserConfigurationException pce) {
			pce.printStackTrace();
		} catch (TransformerException tfe) {
			tfe.printStackTrace();
		} catch (IOException ioe) {
			ioe.printStackTrace();
		} catch (SAXException sae) {
			sae.printStackTrace();
		}
	}

	private static List<Element> getPlugins(Document doc){
		List<Element> elemList = new ArrayList<Element>();

		Element mysema = doc.createElement("plugin");

		Element elem = doc.createElement("groupId");
		elem.appendChild(doc.createTextNode("com.mysema.maven"));
		mysema.appendChild(elem);

		elem = doc.createElement("artifactId");
		elem.appendChild(doc.createTextNode("apt-maven-plugin"));
		mysema.appendChild(elem);

		elem = doc.createElement("version");
		elem.appendChild(doc.createTextNode("1.1.3"));
		mysema.appendChild(elem);

		elem = doc.createElement("executions");

		Element execution = doc.createElement("execution");
		Element goals = doc.createElement("goals");
		Element goal = doc.createElement("goal");

		goal.appendChild(doc.createTextNode("process"));
		goals.appendChild(goal);
		execution.appendChild(goals);

		Element configuration = doc.createElement("configuration");
		Element outputDirectory = doc.createElement("outputDirectory");
		outputDirectory.appendChild(doc.createTextNode("target/generated-sources"));
		Element processor = doc.createElement("processor");
		processor.appendChild(doc.createTextNode("com.querydsl.apt.jpa.JPAAnnotationProcessor"));

		configuration.appendChild(outputDirectory);
		configuration.appendChild(processor);
		execution.appendChild(configuration);

		elem.appendChild(execution);		
		mysema.appendChild(elem);

		elemList.add(mysema);
		elemList.add(getMapStructPlugIn(doc));
		return elemList;
	}

	private static Element getMapStructPlugIn(Document doc)
	{

		Element mapStruct = doc.createElement("plugin");

		Element elem = doc.createElement("groupId");
		elem.appendChild(doc.createTextNode("org.apache.maven.plugins"));
		mapStruct.appendChild(elem);

		elem = doc.createElement("artifactId");
		elem.appendChild(doc.createTextNode("maven-compiler-plugin"));
		mapStruct.appendChild(elem);

		elem = doc.createElement("version");
		elem.appendChild(doc.createTextNode("3.5.1"));
		mapStruct.appendChild(elem);

		Element configuration = doc.createElement("configuration");

		Element source = doc.createElement("source");
		source.appendChild(doc.createTextNode("1.8"));
		Element target = doc.createElement("target");
		target.appendChild(doc.createTextNode("1.8"));

		Element annotationProcessorPaths = doc.createElement("annotationProcessorPaths");
		Element path = doc.createElement("path");
		elem = doc.createElement("groupId");
		elem.appendChild(doc.createTextNode("org.mapstruct"));
		path.appendChild(elem);
		elem = doc.createElement("artifactId");
		elem.appendChild(doc.createTextNode("mapstruct-processor"));
		path.appendChild(elem);
		elem = doc.createElement("version");
		elem.appendChild(doc.createTextNode("1.2.0.Final"));
		path.appendChild(elem);

		annotationProcessorPaths.appendChild(path);
		configuration.appendChild(source);
		configuration.appendChild(target);
		configuration.appendChild(annotationProcessorPaths);

		mapStruct.appendChild(configuration);

		return mapStruct;
	}

	private static void removeScopeTagFromTestDependency(Node dependenciesNode) {
		NodeList dependencies = dependenciesNode.getChildNodes();

		for (int i = 0; i < dependencies.getLength(); i++) {

			Node dependency = dependencies.item(i);
			NodeList dependencyChilds = dependency.getChildNodes();

			Map<String,Object> nodeMap = new HashMap<String,Object>();
			for (int j = 0; j < dependencyChilds.getLength(); j++) {
				Node dependencyChild = dependencyChilds.item(j);
				Map<Integer,String> nm = new HashMap<Integer,String>();
				nm.put(j,dependencyChild.getTextContent());
				nodeMap.put(dependencyChild.getNodeName(), nm);
			}
			if(nodeMap.containsKey("scope")) {
				Map<Integer,String> nm = (Map<Integer, String>) nodeMap.get("artifactId");
				if(nm.containsValue("spring-boot-starter-test")) {
					nm = (Map<Integer, String>) nodeMap.get("scope");
					int nodeIndex = nm.keySet().iterator().next();
					Node scope = dependencyChilds.item(nodeIndex);
					dependency.removeChild(scope);
				}
			}
		}
	}

	private static void removeSpringBootMavenPlugin(Node pluginsNode)
	{
		NodeList plugins = pluginsNode.getChildNodes();
		for (int i = 0; i < plugins.getLength(); i++) {

			Node plugin = plugins.item(i);
			NodeList pluginChilds = plugin.getChildNodes();

			Map<String,Object> pluginMap = new HashMap<String,Object>();
			for (int j = 0; j < pluginChilds.getLength(); j++) {
				Node dependencyChild = pluginChilds.item(j);
				Map<Integer,String> nm = new HashMap<Integer,String>();
				nm.put(j,dependencyChild.getTextContent());
				pluginMap.put(dependencyChild.getNodeName(), nm);
			}
			if(pluginMap.containsKey("artifactId")) {
				Map<Integer,String> nm = (Map<Integer, String>) pluginMap.get("artifactId");
				if(nm.containsValue("spring-boot-maven-plugin")) {
					pluginsNode.removeChild(plugins.item(i));
				}
			}
		}
	}
}
