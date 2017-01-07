/*
 * Jitsi, the OpenSource Java VoIP and Instant Messaging client.
 *
 * Distributable under LGPL license.
 * See terms of license at gnu.org.
 */
package org.jitsi.util;

import com.sun.jna.*;
import java.io.*;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.regex.*;

/**
 * Implements Java Native Interface (JNI)-related facilities such as loading a
 * JNI library from a jar.
 *
 * @author Lyubomir Marinov
 */
public final class JNIUtils
{
    /**
     * The regular expression pattern which matches the file extension
     * &quot;dylib&quot; that is commonly used on Mac OS X for dynamic
     * libraries/shared objects.
     */
    private static final Pattern DYLIB_PATTERN = Pattern.compile("\\.dylib$");

    public static void loadLibrary(String libname, ClassLoader classLoader)
    {
        loadLibrary(libname, null, classLoader);
    }

    public static void loadLibrary(String libname, Class clazz)
    {
        loadLibrary(libname, clazz, clazz.getClassLoader());
    }

    private static void loadLibrary(String libname, Class clazz,
        ClassLoader classLoader)
    {
        try
        {
            if (clazz == null)
            {
                System.loadLibrary(libname);
                return;
            }

            // Hack so that the native library is loaded into the ClassLoader
            // that called this method, and not into the ClassLoader where
            // this code resides. This is necessary for true OSGi environments.
            try
            {
                Method loadLibrary0 = Runtime
                    .getRuntime()
                    .getClass()
                    .getDeclaredMethod("loadLibrary0",
                        Class.class, String.class);
                loadLibrary0.setAccessible(true);
                loadLibrary0.invoke(Runtime.getRuntime(), clazz, libname);
            }
            catch (NoSuchMethodException
                | SecurityException
                | IllegalAccessException
                | IllegalArgumentException
                | InvocationTargetException e)
            {
                System.loadLibrary(libname);
            }
        }
        catch (UnsatisfiedLinkError ulerr)
        {
            // Attempt to extract the library from the resources and load it that
            // way.
            libname = System.mapLibraryName(libname);
            if (Platform.isMac())
                libname = DYLIB_PATTERN.matcher(libname).replaceFirst(".jnilib");

            File embedded;

            try
            {
                embedded
                    = Native.extractFromResourcePath(
                            "/" + Platform.RESOURCE_PREFIX + "/" + libname,
                            classLoader);
            }
            catch (IOException ioex)
            {
                throw ulerr;
            }
            try
            {
                System.load(embedded.getAbsolutePath());
            }
            finally
            {
                // Native.isUnpacked(String) is (package) internal.
                if (embedded.getName().startsWith("jna"))
                {
                    // Native.deleteLibrary(String) is (package) internal.
                    if (!embedded.delete())
                        embedded.deleteOnExit();
                }
            }
        }
    }

    /**
     * Prevents the initialization of new <tt>JNIUtils</tt> instances.
     */
    private JNIUtils()
    {
    }
}
