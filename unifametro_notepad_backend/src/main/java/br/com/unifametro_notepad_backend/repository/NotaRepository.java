package br.com.unifametro_notepad_backend.repository;

import br.com.unifametro_notepad_backend.model.Nota;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

@RepositoryRestResource
public interface NotaRepository extends JpaRepository<Nota, Long> {
}
