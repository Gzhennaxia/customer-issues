package com.customerissue.enums;

import com.baomidou.mybatisplus.annotation.EnumValue;
import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 难度级别枚举
 * 
 * @author Customer Issue System
 */
@Getter
@AllArgsConstructor
public enum DifficultyLevel {
    
    EASY("EASY", "简单"),
    MEDIUM("MEDIUM", "中等"),
    HARD("HARD", "困难");

    @EnumValue
    @JsonValue
    private final String code;
    
    private final String description;

    @JsonCreator
    public static DifficultyLevel fromCode(String code) {
        for (DifficultyLevel level : DifficultyLevel.values()) {
            if (level.getCode().equals(code)) {
                return level;
            }
        }
        throw new IllegalArgumentException("Unknown difficulty level code: " + code);
    }
} 