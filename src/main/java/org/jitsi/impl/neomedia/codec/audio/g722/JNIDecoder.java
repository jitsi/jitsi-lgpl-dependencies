/*
 * Jitsi, the OpenSource Java VoIP and Instant Messaging client.
 *
 * Distributable under LGPL license.
 * See terms of license at gnu.org.
 */
package org.jitsi.impl.neomedia.codec.audio.g722;

import org.jitsi.util.*;

/**
 *
 * @author Lyubomir Marinov
 */
public class JNIDecoder
{
    static
    {
        JNIUtils.loadLibrary("jng722", JNIDecoder.class.getClassLoader());
    }

    public static native void g722_decoder_close(long decoder);

    public static native long g722_decoder_open();

    public static native void g722_decoder_process(
            long decoder,
            byte[] input, int inputOffset,
            byte[] output, int outputOffset, int outputLength);
}
