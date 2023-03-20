package example.micronaut;

import example.micronaut.domain.Thing;
import example.micronaut.domain.USERS;
import example.micronaut.repository.UserRepository;
import io.micronaut.runtime.EmbeddedApplication;
import io.micronaut.test.extensions.junit5.annotation.MicronautTest;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.Assertions;
import jakarta.inject.Inject;


import io.micronaut.context.env.Environment;

import java.sql.Date;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import static org.junit.jupiter.api.Assertions.*;


@MicronautTest(environments = Environment.ORACLE_CLOUD)
class HolistichealthTest {

    @Inject
    EmbeddedApplication<?> application;
    @Inject
    UserRepository userRepository;

    @Test
    void testItWorks() {
        Assertions.assertTrue(application.isRunning());
    }

    @Test
    void testByEmail() {

        userRepository.deleteAll();
        String temp_email = "csdfdsa@usc.edu";
        USERS MichaelCross = new USERS(0,temp_email, "myss", "Judy", "Song", Date.valueOf("2031-03-03"));

        USERS thing = userRepository.findByEmail("csdfdsa@usc.edu").orElse(null);
        assertNull(thing);

        userRepository.save(MichaelCross);
        thing = userRepository.findByEmail(temp_email).orElse(null);
        assertNotNull(thing);
        assertEquals(temp_email, thing.getEMAIL());


    }
}
