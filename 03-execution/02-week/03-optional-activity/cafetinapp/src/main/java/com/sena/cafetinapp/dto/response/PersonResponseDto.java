package com.sena.cafetinapp.dto.response;

import com.fasterxml.jackson.annotation.JsonView;
import com.sena.cafetinapp.dto.view.JsonViews;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class PersonResponseDto {
    @JsonView(JsonViews.Resumen.class)
    private Integer idPerson;

    @JsonView(JsonViews.Resumen.class)
    private String name;

    @JsonView(JsonViews.Resumen.class)
    private String lastname;

    @JsonView(JsonViews.Resumen.class)
    private String email;
}
