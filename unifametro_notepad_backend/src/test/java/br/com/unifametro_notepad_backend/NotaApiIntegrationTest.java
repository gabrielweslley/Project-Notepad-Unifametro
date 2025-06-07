package br.com.unifametro_notepad_backend;

import br.com.unifametro_notepad_backend.model.Nota;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;

import java.time.LocalDateTime;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
public class NotaApiIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Test
    void deveCriarNotaComSucesso() throws Exception {
        Nota nota = Nota.builder()
                .titulo("Teste de Integração")
                .descricao("Criando nota via API")
                .dataCriacao(LocalDateTime.now())
                .build();

        mockMvc.perform(post("/notas")
                        .contentType(org.springframework.http.MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(nota)))
                .andExpect(status().isCreated());
    }
}
