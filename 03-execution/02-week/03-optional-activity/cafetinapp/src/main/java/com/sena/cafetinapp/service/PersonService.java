package com.sena.cafetinapp.service;

import com.sena.cafetinapp.dto.request.PersonRequestDto;
import com.sena.cafetinapp.dto.response.PersonResponseDto;

public interface PersonService 
        extends GenericService<PersonRequestDto, PersonResponseDto, Integer> {

}