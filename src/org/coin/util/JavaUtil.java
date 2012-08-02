package org.coin.util;

import java.io.File;
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.URL;
import java.util.ArrayList;

public class JavaUtil {
	
	public static Class[] getClasses(String sPackageName) 
	throws ClassNotFoundException {
		return getClasses(sPackageName, null);
	}
	public static Class[] getClasses(String sPackageName, String sSuperClass) 
	throws ClassNotFoundException {
		ArrayList<Class> classes = new ArrayList<Class>();
		// Get a File object for the package
		File directory = null;
		try {
			ClassLoader cld = Thread.currentThread().getContextClassLoader();
			if (cld == null) {
				throw new ClassNotFoundException("Can't get class loader.");
			}
			String path = '/' + sPackageName.replace('.', '/');
			URL resource = cld.getResource(path);
			if (resource == null) {
				throw new ClassNotFoundException("No resource for " + path);
			}
			directory = new File(resource.getFile());
		} catch (NullPointerException x) {
			throw new ClassNotFoundException(sPackageName + " (" + directory
					+ ") does not appear to be a valid package");
		}
		if (directory.exists()) {
			// Get the list of the files contained in the package
			String[] files = directory.list();
			for (int i = 0; i < files.length; i++) {
				// we are only interested in .class files without inner class
				if (files[i].endsWith(".class") && !files[i].contains("$")) {
					// removes the .class extension
					Class<?> cl = Class.forName(sPackageName + '.'
							+ files[i].substring(0, files[i].length() - 6));
					if(Outils.isNullOrBlank(sSuperClass)){
						classes.add(cl);
					}else{
						Class<?> clSuper = cl.getSuperclass();
						Class<?> clSuperRequested = loadClass(sSuperClass);
						if(clSuper == clSuperRequested)
							classes.add(cl);
					}
					
					
				}
			}
		} else {
			throw new ClassNotFoundException(sPackageName
					+ " does not appear to be a valid package");
		}
		Class[] classesA = new Class[classes.size()];
		classes.toArray(classesA);
		return classesA;
	}
	
	public static Object invokeMethod(Object obj,String sClassName, String sMethodName, ArrayList arg )
	throws ClassNotFoundException, IllegalArgumentException, IllegalAccessException, InvocationTargetException, 
	SecurityException, NoSuchMethodException{
		Class cl = loadClass(sClassName);
		Class[] argTypes = getArgTypes(arg);
		Method method = cl.getMethod(sMethodName, argTypes);
		return method.invoke(obj,arg.toArray());
	}
	
	public static Object invokeConstructor(String sClassName, ArrayList arg )
	throws ClassNotFoundException, IllegalArgumentException, IllegalAccessException,
	InstantiationException, SecurityException, NoSuchMethodException, InvocationTargetException{
		Class cl = loadClass(sClassName);
		Class[] argTypes = getArgTypes(arg);
		Constructor constructor = cl.getConstructor(argTypes);
		return constructor.newInstance(arg.toArray());
	}
	
	public static Object getPublicFieldValue(Object obj,String sClassName, String sFieldName)
	throws ClassNotFoundException, SecurityException, NoSuchFieldException, 
	IllegalArgumentException, IllegalAccessException {
		Class cl = loadClass(sClassName);
		Field field = cl.getField(sFieldName);
		Object fieldValue = field.get(obj);
		return fieldValue;
	}
	
	public static String[] getDeclaredFieldNames(String sClassName) throws SecurityException, IllegalArgumentException, ClassNotFoundException, NoSuchFieldException, IllegalAccessException{
		return getDeclaredFieldNames(sClassName, null);
	}
	public static String[] getDeclaredFieldNames(String sClassName,String[] sExceptions)
	throws ClassNotFoundException, SecurityException, NoSuchFieldException, 
	IllegalArgumentException, IllegalAccessException {
		Class cl = loadClass(sClassName);
		Field[] fields = cl.getDeclaredFields();

		return fieldToName(fields,sExceptions);
	}
	
	public static String[] getFieldNames(String sClassName) throws SecurityException, IllegalArgumentException, ClassNotFoundException, NoSuchFieldException, IllegalAccessException{
		return getFieldNames(sClassName, null);
	}
	public static String[] getFieldNames(String sClassName,String[] sExceptions)
	throws ClassNotFoundException, SecurityException, NoSuchFieldException, 
	IllegalArgumentException, IllegalAccessException {
		return getFieldNames(sClassName, null, sExceptions);
	}
	
	public static String[] getFieldNames(String sClassName,Class classField,String[] sExceptions)
	throws ClassNotFoundException, SecurityException, NoSuchFieldException, 
	IllegalArgumentException, IllegalAccessException {
		Class cl = loadClass(sClassName);
		Field[] fields = cl.getFields();
		return fieldToName(fields,sExceptions,classField);
	}

	public static String[] fieldToName(Field[] fields,String[] sExceptions)
	throws ClassNotFoundException, SecurityException, NoSuchFieldException, 
	IllegalArgumentException, IllegalAccessException {
		return fieldToName(fields, sExceptions, null);
	}
	public static String[] fieldToName(Field[] fields,String[] sExceptions,Class classField)
	throws ClassNotFoundException, SecurityException, NoSuchFieldException, 
	IllegalArgumentException, IllegalAccessException {
		ArrayList<String> sFieldNameArray = new ArrayList<String>();
		for(int i=0;i<fields.length;i++){
			Field f = fields[i];
			
			boolean bAddField = true;
			if(sExceptions != null)
				for(String sException : sExceptions)
					if(f.getName().equalsIgnoreCase(sException))
						bAddField = false;
			
			if(classField != null)
				if(f.getType()!=classField)
					bAddField = false;
			
			if(bAddField)
				sFieldNameArray.add(f.getName());
		}
		String[] sFieldNames = new String[sFieldNameArray.size()];
		for(int i=0;i<sFieldNameArray.size();i++)
			sFieldNames[i] = sFieldNameArray.get(i);
		
		return sFieldNames;
	}
	
	public static Method[] getMethods(String sClassName) throws ClassNotFoundException {
		Class cl = loadClass(sClassName);
		Method[] methods = cl.getMethods();
		return methods;
	}
	
	public static Method getMethod(String sClassName, String sMethod) throws NoSuchMethodException, SecurityException, IllegalArgumentException, ClassNotFoundException, NoSuchFieldException, IllegalAccessException {
		Method[] methods = getMethods(sClassName);
		for(Method method : methods){
			if(method.getName().equalsIgnoreCase(sMethod))
				return method;
		}
		throw new NoSuchMethodException(sMethod);
	}
	
	public static Method getMethod(String sClassName, String sMethod, int iNumParams) throws NoSuchMethodException, SecurityException, IllegalArgumentException, ClassNotFoundException, NoSuchFieldException, IllegalAccessException {
		Method[] methods = getMethods(sClassName);
		for(Method method : methods){
			if(method.getName().equalsIgnoreCase(sMethod)
					&& method.getParameterTypes().length==iNumParams)
				return method;
		}
		throw new NoSuchMethodException(sMethod);
	}
	
	public static Method getMethod(String sClassName, String sMethod,ArrayList<?> paramList) throws NoSuchMethodException, SecurityException, IllegalArgumentException, ClassNotFoundException, NoSuchFieldException, IllegalAccessException {
		Class<?> cl = loadClass(sClassName);
		Class<?>[] argTypes = getArgTypes(paramList);
		return cl.getMethod(sMethod, argTypes);
	}
	
	public static Class[] getConstructorParamType(String sClassName, int iIndexConstructor)
	throws ClassNotFoundException, IllegalArgumentException, IllegalAccessException, 
	InstantiationException, SecurityException, NoSuchMethodException, InvocationTargetException{
		Class cl = loadClass(sClassName);
		Constructor[] constructors = cl.getConstructors();
		ArrayList<Constructor> constructorsWithParams = new ArrayList<Constructor>();
		for(Constructor constructor : constructors){
			Class[] paramTypes = constructor.getParameterTypes();
			if(paramTypes.length>0){
				constructorsWithParams.add(constructor);
			}		
		}
		return constructorsWithParams.get(iIndexConstructor).getParameterTypes();
	}
	
	public static Class loadClass(String sClassName) 
	throws ClassNotFoundException {
		ClassLoader cld = Thread.currentThread().getContextClassLoader();
		if (cld == null) {
			throw new ClassNotFoundException("Can't get class loader.");
		}
		return cld.loadClass(sClassName);
	}
	
	public static Class<?>[] getArgTypes(ArrayList<?> arg)  {
		Class<?>[] argTypes = new Class[arg.size()]; 
		for(int i=0;i<arg.size();i++){
			if(arg.get(i).getClass() == Integer.class)
				argTypes[i] = int.class;
			else if(arg.get(i).getClass() == Long.class)
				argTypes[i] = long.class;
			else if(arg.get(i).getClass() == Boolean.class)
				argTypes[i] = boolean.class;
			else if(arg.get(i).getClass() == Float.class)
				argTypes[i] = float.class;
			else
				argTypes[i] = arg.get(i).getClass();
			
			try{
				@SuppressWarnings("unused")
				Object testCastConn = (java.sql.Connection)arg.get(i);
				argTypes[i] = java.sql.Connection.class;
			}catch(Exception e){}
		}

		return argTypes;
	}
	
	
	public static ArrayList convertArgs(String[] params, Class[] argClasses)  {
		ArrayList newArg = new ArrayList();
		for(int i=0;i<argClasses.length;i++){
			Class argClass = argClasses[i];
			if(argClass == int.class)
				newArg.add(Integer.parseInt(params[i]));
			else if(argClass == long.class)
				newArg.add(Long.parseLong(params[i]));
			else if(argClass == boolean.class)
				newArg.add(Boolean.parseBoolean(params[i]));
			else if(argClass == float.class)
				newArg.add(Float.parseFloat(params[i]));
			else
				newArg.add(params[i]);
		}
		return newArg;
	}

}
