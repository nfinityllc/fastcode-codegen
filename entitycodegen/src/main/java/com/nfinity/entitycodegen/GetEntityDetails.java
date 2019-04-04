package com.nfinity.entitycodegen;

import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;

public class GetEntityDetails {

	public static EntityDetails getDetails(String entityPath, String entityName) {

		Map<String, FieldDetails> fieldsMap = new HashMap<>();
		Map<String, RelationDetails> relationsMap = new HashMap<>();
		Class<?> myClass;
		try {
			myClass = Class.forName(entityName);
			Object classObj = (Object) myClass.newInstance();
			Field[] fields = classObj.getClass().getDeclaredFields();

			for (Field field : fields) {
				FieldDetails details = new FieldDetails();
				RelationDetails relation = new RelationDetails();
				String str = field.getType().toString();
				int index = str.lastIndexOf(".") + 1;
				details.setFieldName(field.getName());
				details.setFieldType(str.substring(index));
				Annotation[] annotations = field.getDeclaredAnnotations();
				for (Annotation a : annotations) {
					if (a.annotationType().toString().equals("interface javax.persistence.Column")) {
						String column = a.toString();
						String[] word = column.split("[\\(,//)]");
						for (String s : word) {
							if (s.contains("nullable")) {
								String[] value = s.split("=");
								Boolean nullable = Boolean.valueOf(value[1]);
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
					}
					if (a.annotationType().toString().equals("interface javax.persistence.ManyToOne")) {
						relation.setRelation("ManyToOne");
						relation.setfName(field.getName());
						relation.seteName(details.getFieldType());
					}

					if (a.annotationType().toString().equals("interface javax.persistence.JoinColumn")) {
						String joinColumn = a.toString();
						String[] word = joinColumn.split("[\\(,//)]");
						for (String s : word) {
							if (s.contains("name")) {
								String[] value = s.split("=");
								relation.setJoinColumn(value[1]);
								break;
							}
						}
					}

					if (a.annotationType().toString().equals("interface javax.persistence.OneToMany")) {

						String relationalEntity = a.toString();
						String entityPackage = null;
						String[] word = relationalEntity.split("[\\(,//)]");
						for (String s : word) {
							if (s.contains("targetEntity")) {
								String[] value = s.split(" ");
								entityPackage = value[1];
							}

						}

						String targetEntity = entityPackage.substring(entityPackage.lastIndexOf(".") + 1);

						Boolean isJoinTable = checkJoinTable(entityPackage, targetEntity);
						if (isJoinTable) {
							List<Map<String, String>> joinInfo = getFieldsIfJoinTable(entityPackage, targetEntity);
							relation.setRelation("ManyToMany");
							relation.setJoinTable(targetEntity);
							for (Map<String, String> map : joinInfo) {
								String className = entityName.substring(entityName.lastIndexOf(".") + 1);

								if (className.equals(map.get("fieldType"))) {
									relation.setJoinColumn(map.get("joinColumn"));
									relation.setReferenceColumn(map.get("referenceColumn"));
								} else {
									relation.setfName(map.get("fieldName"));
									details.setFieldName(map.get("fieldName"));
									details.setFieldType(map.get("fieldType"));
									relation.seteName(map.get("fieldType"));
									relation.setInverseJoinColumn(map.get("joinColumn"));
									relation.setInverseReferenceColumn(map.get("referenceColumn"));
								}
							}
						} else {
							relation.setRelation("OneToMany");
							details.setFieldName(targetEntity.toLowerCase());
							details.setFieldType(targetEntity);
							relation.seteName(targetEntity);
							relation.setfName(targetEntity.toLowerCase());
							String mappedBy = null;
							for (String s : word) {
								if (s.contains("mappedBy")) {
									String[] value = s.split("=");
									mappedBy = value[1];
								}
							}
							relation.setMappedBy(mappedBy);

						}
					}
				}

				if (relation.geteName() != null)
					relationsMap.put(relation.getRelation(), relation);

				fieldsMap.put(details.getFieldName(), details);
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (InstantiationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return new EntityDetails(fieldsMap, relationsMap);
	}

	private static Boolean checkJoinTable(String EntityPackage, String EntityName) {
		try {
			Class<?> myClass = Class.forName(EntityPackage);
			Object classObj = (Object) myClass.newInstance();
			Annotation[] classAnnotations = classObj.getClass().getAnnotations();

			for (Annotation a : classAnnotations) {
				if (a.annotationType().toString().equals("interface javax.persistence.IdClass")) {
					return true;
				}
			}
		} catch (ClassNotFoundException e) {
		} catch (InstantiationException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		}
		return false;
	}

	private static List<Map<String, String>> getFieldsIfJoinTable(String EntityPackage, String EntityName) {

		List<Map<String, String>> relationShipFields = new ArrayList<>();

		Class<?> myClass;
		try {
			myClass = Class.forName(EntityPackage);
			Object classObj = (Object) myClass.newInstance();

			Field[] fields = classObj.getClass().getDeclaredFields();
			for (Field field : fields) {
				Annotation[] annotations = field.getDeclaredAnnotations();
				Map<String, String> relationFields = new HashMap<>();
				for (Annotation a : annotations) {
					if (a.annotationType().toString().equals("interface javax.persistence.ManyToOne")) {
						String str = field.getType().toString();
						int index = str.lastIndexOf(".") + 1;
						relationFields.put("fieldName", field.getName());
						relationFields.put("fieldType", str.substring(index));

					}
					if (a.annotationType().toString().equals("interface javax.persistence.JoinColumn")) {
						String str = a.toString();
						int index = str.indexOf("name");
						relationFields.put("joinColumn", str.substring(index + 5, str.indexOf(",", index)));
					}
				}

				if (relationFields.get("fieldType") != null) {
					String entity = StringUtils.substringBeforeLast(EntityPackage, ".");
					String referenceColumn = findPrimaryKey(entity.concat("." + relationFields.get("fieldType")),
							relationFields.get("fieldType"));
					if (referenceColumn != null)
						relationFields.put("referenceColumn", referenceColumn);
				}

				if (relationFields.get("fieldName") != null)
					relationShipFields.add(relationFields);
			}

		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (InstantiationException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		}

		return relationShipFields;
	}

	private static String findPrimaryKey(String entityPackage, String entityName) {
		String primaryKey = null;
		Class<?> myClass;
		try {
			myClass = Class.forName(entityPackage);
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
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (InstantiationException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		}
		return null;
	}

}
