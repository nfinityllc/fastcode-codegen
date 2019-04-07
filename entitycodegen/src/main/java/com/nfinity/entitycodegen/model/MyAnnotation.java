package com.nfinity.entitycodegen.model;

import javax.persistence.*;
import java.sql.Timestamp;
import java.util.Objects;
import java.lang.annotation.*;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.FIELD)
public @interface MyAnnotation {
    String codegen();
}
