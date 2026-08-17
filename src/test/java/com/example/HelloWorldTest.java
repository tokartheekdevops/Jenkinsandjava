package com.example;

import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class HelloWorldTest {

    @Test
    public void testHelloWorld() {

        String expected = "Hello, World!";
        String actual = "Hello, World!";

        assertEquals(expected, actual);
    }
}
