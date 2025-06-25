package com.customerissue.enums;

import com.baomidou.mybatisplus.annotation.EnumValue;
import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;
import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 问题状态枚举
 * 
 * @author Customer Issue System
 */
@Getter
@AllArgsConstructor
public enum IssueStatus {
    
    OPEN("OPEN", "开放"),
    IN_PROGRESS("IN_PROGRESS", "处理中"),
    RESOLVED("RESOLVED", "已解决"),
    CLOSED("CLOSED", "已关闭");

    @EnumValue
    @JsonValue
    private final String code;
    
    private final String description;

    @JsonCreator
    public static IssueStatus fromCode(String code) {
        for (IssueStatus status : IssueStatus.values()) {
            if (status.getCode().equals(code)) {
                return status;
            }
        }
        throw new IllegalArgumentException("Unknown issue status code: " + code);
    }
} 