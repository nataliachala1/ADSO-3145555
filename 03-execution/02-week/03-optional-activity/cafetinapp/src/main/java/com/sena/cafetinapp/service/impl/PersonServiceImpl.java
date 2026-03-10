package com.sena.cafetinapp.service.impl;

import com.sena.cafetinapp.dto.request.PersonRequestDto;
import com.sena.cafetinapp.dto.response.PersonResponseDto;
import com.sena.cafetinapp.model.Person;
import com.sena.cafetinapp.repository.PersonRepository;
import com.sena.cafetinapp.service.PersonService;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PersonServiceImpl implements PersonService {

    private final PersonRepository repository;

    @Override
    public PersonResponseDto create(PersonRequestDto request) {
        Person entity = new Person();
        entity.setName(request.getName());
        entity.setLastname(request.getLastname());
        entity.setEmail(request.getEmail());

        Person saved = repository.save(entity);
        return mapToDto(saved);
    }

    @Override
    public PersonResponseDto update(Integer id, PersonRequestDto request) {
        Person entity = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Persona no encontrada"));

        entity.setName(request.getName());
        entity.setLastname(request.getLastname());
        entity.setEmail(request.getEmail());

        Person updated = repository.save(entity);
        return mapToDto(updated);
    }

    @Override
    public PersonResponseDto findById(Integer id) {
        Person entity = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Persona no encontrada"));
        return mapToDto(entity);
    }

    @Override
    public List<PersonResponseDto> findAll() {
        return repository.findAll()
                .stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    @Override
    public void delete(Integer id) {
        repository.deleteById(id);
    }

    private PersonResponseDto mapToDto(Person entity) {
        return PersonResponseDto.builder()
                .idPerson(entity.getIdPerson())
                .name(entity.getName())
                .lastname(entity.getLastname())
                .email(entity.getEmail())
                .build();
    }
}