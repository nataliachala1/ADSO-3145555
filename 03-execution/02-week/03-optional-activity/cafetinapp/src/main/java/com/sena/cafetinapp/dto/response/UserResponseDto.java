package com.sena.cafetinapp.dto.response;

import com.fasterxml.jackson.annotation.JsonView;
import com.sena.cafetinapp.dto.view.JsonViews;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class UserResponseDto {

    @JsonView(JsonViews.Resumen.class)
    private Integer idUser;

    @JsonView(JsonViews.Resumen.class)
    private String name;

    @JsonView(JsonViews.Resumen.class)
    private String lastname;

    @JsonView(JsonViews.Resumen.class)
    private String email;

    @JsonView(JsonViews.Resumen.class)
    private Boolean active;

    //El rol completo solo se muestra en ld vista detalle
    @JsonView(JsonViews.Detalle.class)
    private RolResponseDto rol;
}
