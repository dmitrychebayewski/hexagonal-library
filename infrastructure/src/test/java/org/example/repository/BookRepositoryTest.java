package org.example.repository;

import org.example.BaseIntegrationTest;
import org.junit.Test;
import org.mockito.Mock;
import org.springframework.test.context.ActiveProfiles;

import static org.junit.Assert.assertNotNull;

@ActiveProfiles("test")
public class BookRepositoryTest extends BaseIntegrationTest {
    @Mock
    private BookRepository bookRepository;

    @Test
    public void getBookRepository() {
        assertNotNull(bookRepository);
    }
}