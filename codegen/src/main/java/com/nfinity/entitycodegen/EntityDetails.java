package com.nfinity.entitycodegen;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.stream.Collectors;

import org.apache.commons.lang3.StringUtils;
import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import com.google.common.base.CaseFormat;

public class EntityDetails {

	Map<String, FieldDetails> fieldsMap = new HashMap<>();
	Map<String, RelationDetails> relationsMap = new HashMap<>();
	List<String> compositeKeyClasses = new ArrayList<>();
	Map<String, FieldDetails> entitiesDescriptiveFieldMap = new HashMap<>();

	public Map<String, FieldDetails> getEntitiesDescriptiveFieldMap() {
		return entitiesDescriptiveFieldMap;
	}

	public void setEntitiesDescriptiveFieldMap(Map<String, FieldDetails> entitiesDescriptiveFieldMap) {
		this.entitiesDescriptiveFieldMap = entitiesDescriptiveFieldMap;
	}

	public EntityDetails(Map<String, FieldDetails> fieldsMap, Map<String, RelationDetails> relationsMap) {
		super();
		this.fieldsMap = fieldsMap;
		this.relationsMap = relationsMap;
	}

	public Map<String, FieldDetails> getFieldsMap() {
		return fieldsMap;
	}

	public void setFieldsMap(Map<String, FieldDetails> fieldsMap) {
		this.fieldsMap = fieldsMap;
	}

	public Map<String, RelationDetails> getRelationsMap() {
		return relationsMap;
	}

	public void setRelationsMap(Map<String, RelationDetails> relationsMap) {
		this.relationsMap = relationsMap;
	}

	public List<String> getCompositeKeyClasses() {
		return compositeKeyClasses;
	}

	public void setCompositeKeyClasses(List<String> compositeKeyClasses) {
		this.compositeKeyClasses = compositeKeyClasses;
	}

	public static EntityDetails retreiveEntityFieldsAndRships(Class<?> entityClass, String entityName,
			List<Class<?>> classList) {

		Map<String, FieldDetails> fieldsMap = new HashMap<>();
		Map<String, RelationDetails> relationsMap = new HashMap<>();
		List<JoinDetails> joinDetailsList= new ArrayList<JoinDetails>();
		String className = entityName.substring(entityName.lastIndexOf(".") + 1);
		System.out.println(" entity name " + className);

		try {

			Class<?> myClass = entityClass;
			Object classObj = (Object) myClass.newInstance();
			Field[] fields = classObj.getClass().getDeclaredFields();
			
			for (Field field : fields) {
				FieldDetails details = new FieldDetails();
				RelationDetails relation = new RelationDetails();
				JoinDetails joinDetails=new JoinDetails();
				String str = field.getType().toString();
				int index = str.lastIndexOf(".") + 1;
				details.setFieldName(field.getName());
				String fieldType=str.substring(index);
				if(fieldType.equals("int"))
				{
					fieldType="Integer";
				}
				fieldType=fieldType.substring(0, 1).toUpperCase() + fieldType.substring(1);
				details.setFieldType(fieldType);
				Annotation[] annotations = field.getAnnotations();
				relation.setcName(className);
				for (Annotation a : annotations) {
					
					if (a.annotationType().toString().equals("interface javax.persistence.Column")) {
						String column = a.toString();
						String[] word = column.split("[\\(,//)]");
						for (String s : word) {
							if (s.contains("nullable")) {
								String[] value = s.split("=");
								Boolean nullable = Boolean.valueOf(value[1]);
								if (details.getIsNullable())
									details.setIsNullable(nullable);

							}
							if (s.contains("length")) {
								String[] value = s.split("=");
								int length = Integer.valueOf(value[1]);
								details.setLength(length);
							}
						}
					}
					if (a.annotationType().toString().equals("interface javax.persistence.Id")) {
						details.setIsPrimaryKey(true);
						details.setIsNullable(false);
					}
					if (a.annotationType().toString().equals("interface javax.persistence.ManyToOne")) {
						relation.setRelation("ManyToOne");
						relation.setfName(field.getName());
						relation.seteName(details.getFieldType());
						joinDetails.setJoinEntityName(details.getFieldType());
					}
					if (a.annotationType().toString().equals("interface javax.persistence.OneToOne")) {
						relation.setRelation("OneToOne");
						relation.setfName(field.getName());
						relation.seteName(details.getFieldType());
						joinDetails.setJoinEntityName(details.getFieldType());
						String[] word = a.toString().split("[\\(,//)]");
						String mappedBy = null;
						for (String s : word) {
							if (s.contains("mappedBy")) {
								String[] value = s.split("=");
								if(value.length>1)
								{
								mappedBy = value[1];
								relation.setIsParent(true);
								}
							}
							else
								relation.setIsParent(false);
						}
						System.out.println("mapped by "  + mappedBy);
						joinDetails.setMappedBy(mappedBy);
					}

					if (a.annotationType().toString().equals("interface javax.persistence.JoinColumn")) {
						String joinColumn = a.toString();
						String[] word = joinColumn.split("[\\(,//)]");
						for (String s : word) {
							if (s.contains("name")) {
								String[] value = s.split("=");
								joinDetails.setJoinColumn(
										CaseFormat.LOWER_UNDERSCORE.to(CaseFormat.LOWER_CAMEL, value[1]));
								break;
							}
						}
						for (String s : word) {
							if (s.contains("nullable")) {
								String[] value = s.split("=");
								Boolean nullable = Boolean.valueOf(value[1]);
								joinDetails.setIsJoinColumnOptional(nullable);
							}
							if (s.contains("columnDefinition")) {
								String[] value = s.split("=");
								if(value.length>1)
								{
								String columnType = value[1];
								if (columnType.equals("bigserial") || columnType.equals("int8")
										|| columnType.equals("int4"))
									joinDetails.setJoinColumnType("Long");
								else
									joinDetails.setJoinColumnType("String");
								}
								else
									joinDetails.setJoinColumnType("String");
							}

						}
						if (joinDetails.getJoinColumn() != null) {
							String entity = StringUtils.substringBeforeLast(entityName, ".");
							String referenceColumn = findPrimaryKey(
									entity.concat("." + relation.geteName()), classList);
							if (referenceColumn != null)
								joinDetails.setReferenceColumn(referenceColumn);
						
						//	System.out.println(" reference coll " + referenceColumn);
						}

						
					}

					if (a.annotationType().toString().equals("interface javax.persistence.OneToMany")) {

						String relationalEntity = a.toString();
//						String entityPackage = null;
						String[] word = relationalEntity.split("[\\(,//)]");
//						for (String s : word) {
//							if (s.contains("targetEntity")) {
//								String[] value = s.split(" ");
//								if(value.length>1)
//								{
//								entityPackage = value[1];
//								}
//							}
//
//						}
//						String targetEntity = entityPackage.substring(entityPackage.lastIndexOf(".") + 1);
//							relation.setRelation("OneToMany");
//							details.setFieldName(targetEntity.toLowerCase());
//							details.setFieldType(targetEntity);
//							relation.seteName(targetEntity);
//							relation.setfName(targetEntity.toLowerCase());
							String mappedBy = null;
							for (String s : word) {
								if (s.contains("mappedBy")) {
									String[] value = s.split("=");
									if(value.length>1)
									{
									mappedBy = value[1];
									}
								}
							}
							joinDetails.setMappedBy(mappedBy);

						}
	
				}
				
			
				if (relation.geteName() != null) {
					 joinDetailsList.add(joinDetails);
					 
					 Set<JoinDetails> setOfJoinDetails = new LinkedHashSet<>(joinDetailsList);

					 joinDetailsList.clear();
					 joinDetailsList.addAll(setOfJoinDetails);
                   
					relation.setJoinDetails(joinDetailsList);
					relation.setfDetails(getFields(relation.geteName(), classList));
					relationsMap.put(className + "-" + relation.geteName(), relation);
				}

				fieldsMap.put(details.getFieldName(), details);
			}
		} catch (InstantiationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		Map<String, FieldDetails> sortedMap = new TreeMap<>(fieldsMap);
		return new EntityDetails(sortedMap, relationsMap);
	}

	private static Boolean checkJoinTable(String EntityPackage, List<Class<?>> classList) {
		for (Class<?> currentClass : classList) {
			String entityName = currentClass.getName();
			if (entityName.equals(EntityPackage)) {
				try {
					Class<?> myClass = currentClass;
					Object classObj = (Object) myClass.newInstance();
					Annotation[] classAnnotations = classObj.getClass().getAnnotations();

					for (Annotation a : classAnnotations) {
						if (a.annotationType().toString().equals("interface javax.persistence.IdClass")) {
							return true;
						}
					}
				} catch (InstantiationException e) {
					e.printStackTrace();
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				}
			}
		}
		return false;
	}

//	private static List<Map<String, String>> getFieldsIfJoinTable(String EntityPackage, List<Class<?>> classList) {
//
//		List<Map<String, String>> relationShipFields = new ArrayList<>();
//
//		for (Class<?> currentClass : classList) {
//			String entityName = currentClass.getName();
//			if (entityName.equals(EntityPackage)) {
//				try {
//					Class<?> myClass = currentClass;
//					Object classObj = (Object) myClass.newInstance();
//
//					Field[] fields = classObj.getClass().getDeclaredFields();
//					for (Field field : fields) {
//						Annotation[] annotations = field.getDeclaredAnnotations();
//						Map<String, String> relationFields = new HashMap<>();
//						for (Annotation a : annotations) {
//							if (a.annotationType().toString().equals("interface javax.persistence.ManyToOne")) {
//								String str = field.getType().toString();
//								int index = str.lastIndexOf(".") + 1;
//								relationFields.put("fieldName", field.getName());
//								relationFields.put("fieldType", str.substring(index));
//
//							}
//							if (a.annotationType().toString().equals("interface javax.persistence.JoinColumn")) {
//								String str = a.toString();
//								String[] word = str.split("[\\(,//)]");
//								for (String s : word) {
//									if (s.contains("name")) {
//										String[] value = s.split("=");
//										relationFields.put("joinColumn",
//												CaseFormat.LOWER_UNDERSCORE.to(CaseFormat.LOWER_CAMEL, value[1]));
//										break;
//									}
//								}
//								for (String s : word) {
//									if (s.contains("nullable")) {
//										String[] value = s.split("=");
//										// Boolean nullable = Boolean.valueOf(value[1]);
//										relationFields.put("isJoinColumnOptional", value[1]);
//									}
//									if (s.contains("columnDefinition")) {
//										String[] value = s.split("=");
//										if(value.length>1)
//										{	
//										String columnType = value[1];
//										if (columnType.equals("bigserial") || columnType.equals("int8")
//												|| columnType.equals("int4"))
//											relationFields.put("joinColumnType", "Long");
//										else
//											relationFields.put("joinColumnType", "String");
//										}
//										else
//											relationFields.put("joinColumnType", "String");
//									}
//								}
//							}
//						}
//
//						if (relationFields.get("fieldType") != null) {
//							String entity = StringUtils.substringBeforeLast(EntityPackage, ".");
//							String referenceColumn = findPrimaryKey(
//									entity.concat("." + relationFields.get("fieldType")), classList);
//							if (referenceColumn != null)
//								relationFields.put("referenceColumn", referenceColumn);
//						}
//						
//
//						if (relationFields.get("fieldName") != null)
//							relationShipFields.add(relationFields);
//					}
//
//				} catch (InstantiationException e) {
//					e.printStackTrace();
//				} catch (IllegalAccessException e) {
//					e.printStackTrace();
//				}
//			}
//		}
//
//		return relationShipFields;
//	}

	private static String findPrimaryKey(String entityPackage, List<Class<?>> classList) {
		String primaryKey = null;

		for (Class<?> currentClass : classList) {
			String entityName = currentClass.getName();
			if (entityName.equals(entityPackage)) {
				try {
					Class<?> myClass = currentClass;
					Object classObj = (Object) myClass.newInstance();
					Field[] fields = classObj.getClass().getDeclaredFields();
					for (Field field : fields) {
						Annotation[] annotations = field.getDeclaredAnnotations();

						for (Annotation a : annotations) {
							if (a.annotationType().toString().equals("interface javax.persistence.Id")) {
								primaryKey = field.getName();
								return primaryKey;
							}
						}
					}
				} catch (InstantiationException e) {
					e.printStackTrace();
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				}
			}
		}
		return null;
	}

	private static List<FieldDetails> getFields(String relationEntityName, List<Class<?>> classList) {
		List<FieldDetails> fieldsList = new ArrayList<>();
		for (Class<?> currentClass : classList) {
			String entityName = currentClass.getName().substring(currentClass.getName().lastIndexOf(".") + 1);
			if (entityName.equals(relationEntityName)) {
				try {
					Class<?> myClass = currentClass;
					Object classObj = (Object) myClass.newInstance();
					Field[] fields = classObj.getClass().getDeclaredFields();
					for (Field field : fields) {
						FieldDetails details = new FieldDetails();
						String str = field.getType().toString();
						int index = str.lastIndexOf(".") + 1;
						details.setFieldName(field.getName());
						details.setFieldType(str.substring(index));
						Annotation[] annotations = field.getAnnotations();
						for (Annotation a : annotations) {

							if (a.annotationType().toString().equals("interface javax.persistence.Id")) {
								details.setIsPrimaryKey(true);
							}
						}
						fieldsList.add(details);
					}

				} catch (InstantiationException e) {
					e.printStackTrace();
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				}
			}
		}

		return fieldsList;

	}

	public static Map<String, RelationDetails> FindOneToManyJoinColFromChildEntity(
			Map<String, RelationDetails> relationMap, List<Class<?>> classList) {
		
		for (Map.Entry<String, RelationDetails> entry : relationMap.entrySet()) {
			
			if (entry.getValue().getRelation() == "OneToMany") {
				List<JoinDetails> joinDetailsList= new ArrayList<JoinDetails>();
				for (Class<?> currentClass : classList) {
					String entityName = currentClass.getName().substring(currentClass.getName().lastIndexOf(".") + 1);
					if (entityName.equals(entry.getValue().geteName())) {
						
						try {
							Class<?> myClass = currentClass;
							Object classObj = (Object) myClass.newInstance();
							Field[] fields = classObj.getClass().getDeclaredFields();
							
							for (Field field : fields) {
								Annotation[] annotations = field.getAnnotations();
								JoinDetails joinDetails=new JoinDetails();
								for (Annotation a : annotations) {
									
									if (a.annotationType().toString().equals("interface javax.persistence.JoinColumn")) {
										String joinColumn = a.toString();
										String[] word = joinColumn.split("[\\(,//)]");
										for (String s : word) {
											if (s.contains("name")) {
												String[] value = s.split("=");
												joinDetails.setJoinColumn(
														CaseFormat.LOWER_UNDERSCORE.to(CaseFormat.LOWER_CAMEL, value[1]));
												break;
											}
										}
										for (String s : word) {
											if (s.contains("nullable")) {
												String[] value = s.split("=");
												Boolean nullable = Boolean.valueOf(value[1]);
												joinDetails.setIsJoinColumnOptional(nullable);
											}
											if (s.contains("columnDefinition")) {
												String[] value = s.split("=");
												if(value.length>1)
												{
												String columnType = value[1];
												if (columnType.equals("bigserial") || columnType.equals("int8")
														|| columnType.equals("int4"))
													joinDetails.setJoinColumnType("Long");
												else
													joinDetails.setJoinColumnType("String");
												}
												else
													joinDetails.setJoinColumnType("String");
											}

										}
										
										if (joinDetails.getJoinColumn() != null) {
											String entity = StringUtils.substringBeforeLast(entityName, ".");
											String referenceColumn = findPrimaryKey(
													entity.concat("." + entry.getValue().geteName()), classList);
											if (referenceColumn != null)
												joinDetails.setReferenceColumn(referenceColumn);
							
										}
									}
								}
								 
								

							}
							 Set<JoinDetails> setOfJoinDetails = new LinkedHashSet<>(joinDetailsList);

							 joinDetailsList.clear();
							 joinDetailsList.addAll(setOfJoinDetails);
							 entry.getValue().setJoinDetails(joinDetailsList);

						} catch (InstantiationException e) {
							e.printStackTrace();
						} catch (IllegalAccessException e) {
							e.printStackTrace();
						}
						
					}
					
				}
               
			}
		}

		return relationMap;
	}

}
