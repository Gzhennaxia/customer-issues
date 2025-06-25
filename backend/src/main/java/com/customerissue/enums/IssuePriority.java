package com.customerissue.enums;

import com.baomidou.mybatisplus.annotation.EnumValue;
import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 问题优先级枚举
 * 
 * @author Customer Issue System
 */
@Getter
@AllArgsConstructor
public enum IssuePriority {
    
    LOW("LOW", "低"),
    MEDIUM("MEDIUM", "中"),
    HIGH("HIGH", "高"),
    CRITICAL("CRITICAL", "紧急");

    @EnumValue
    @JsonValue
    private final String code;
    
    private final String description;

    @JsonCreator
    public static IssuePriority fromCode(String code) {
        for (IssuePriority priority : IssuePriority.values()) {
            if (priority.getCode().equals(code)) {
                return priority;
            }
        }
        throw new IllegalArgumentException("Unknown issue priority code: " + code);
    }
} 