package br.com.unifametro_notepad_backend.model;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;

import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.assertEquals;

@DataJpaTest
public class NotaTest {

    @Test
    public void testeNotaConstrutorEGetters() {
        Nota nota = Nota.builder()
                .titulo("titulo1")
                .descricao("descricao1")
                .dataCriacao(LocalDateTime.now()).build();

        assertEquals("titulo1", nota.getTitulo());
        assertEquals("descricao1", nota.getDescricao());

    }

    @Test
    void testeNotaSetter() {
        Nota nota = new Nota();
        nota.setId(2L);
        nota.setTitulo("titulo2");
        nota.setDescricao("descricao2");

        assertEquals(2L, nota.getId());
        assertEquals("titulo2", nota.getTitulo());
        assertEquals("descricao2", nota.getDescricao());
    }
}
