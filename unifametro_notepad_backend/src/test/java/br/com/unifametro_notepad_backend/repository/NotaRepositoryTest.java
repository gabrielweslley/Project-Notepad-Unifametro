package br.com.unifametro_notepad_backend.repository;

import br.com.unifametro_notepad_backend.model.Nota;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;

import java.time.LocalDateTime;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

@DataJpaTest
public class NotaRepositoryTest {

    @Autowired
    NotaRepository repository;

    @Test
    void testeSalvarNota() {
        Nota nota = Nota.builder()
                .titulo("titulo1")
                .descricao("descricao1")
                .dataCriacao(LocalDateTime.now()).build();

        Nota notaSalva = repository.save(nota);

        assertNotNull(notaSalva.getId());
        assertEquals("titulo1", nota.getTitulo());
    }

    @Test
    void testBuscarNotaPorId() {

        Nota nota = Nota.builder()
                .titulo("titulo1")
                .descricao("descricao1")
                .dataCriacao(LocalDateTime.now()).build();

        Nota notaSalva = repository.save(nota);

        Optional<Nota> notaBuscada = repository.findById(nota.getId());
        assertTrue(notaBuscada.isPresent());
        assertEquals("titulo1", notaBuscada.get().getTitulo());
    }
}
