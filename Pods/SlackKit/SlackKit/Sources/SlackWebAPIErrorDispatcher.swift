//
// SlackWebAPIErrorHandling.swift
//
// Copyright © 2016 Peter Zignego. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

public enum SlackError: ErrorType {
    case AccountInactive
    case AlreadyArchived
    case AlreadyInChannel
    case AlreadyPinned
    case AlreadyReacted
    case AlreadyStarred
    case BadClientSecret
    case BadRedirectURI
    case BadTimeStamp
    case CantArchiveGeneral
    case CantDelete
    case CantDeleteFile
    case CantDeleteMessage
    case CantInvite
    case CantInviteSelf
    case CantKickFromGeneral
    case CantKickFromLastChannel
    case CantKickSelf
    case CantLeaveGeneral
    case CantLeaveLastChannel
    case CantUpdateMessage
    case ChannelNotFound
    case ComplianceExportsPreventDeletion
    case EditWindowClosed
    case FileCommentNotFound
    case FileDeleted
    case FileNotFound
    case FileNotShared
    case GroupContainsOthers
    case InvalidArrayArg
    case InvalidAuth
    case InvalidChannel
    case InvalidCharSet
    case InvalidClientID
    case InvalidCode
    case InvalidFormData
    case InvalidName
    case InvalidPostType
    case InvalidPresence
    case InvalidTS
    case InvalidTSLatest
    case InvalidTSOldest
    case IsArchived
    case LastMember
    case LastRAChannel
    case MessageNotFound
    case MessageTooLong
    case MigrationInProgress
    case MissingDuration
    case MissingPostType
    case NameTaken
    case NoChannel
    case NoComment
    case NoItemSpecified
    case NoReaction
    case NoText
    case NotArchived
    case NotAuthed
    case NotEnoughUsers
    case NotInChannel
    case NotInGroup
    case NotPinned
    case NotStarred
    case OverPaginationLimit
    case PaidOnly
    case PermissionDenied
    case PostingToGeneralChannelDenied
    case RateLimited
    case RequestTimeout
    case RestrictedAction
    case SnoozeEndFailed
    case SnoozeFailed
    case SnoozeNotActive
    case TooLong
    case TooManyEmoji
    case TooManyReactions
    case TooManyUsers
    case UnknownError
    case UnknownType
    case UserDisabled
    case UserDoesNotOwnChannel
    case UserIsBot
    case UserIsRestricted
    case UserIsUltraRestricted
    case UserListNotSupplied
    case UserNotFound
    case UserNotVisible
    // Client
    case ClientNetworkError
}

internal struct ErrorDispatcher {
    
    static func dispatch(error: String) -> SlackError {
        switch error {
        case "account_inactive":
            return .AccountInactive
        case "already_in_channel":
            return .AlreadyInChannel
        case "already_pinned":
            return .AlreadyPinned
        case "already_reacted":
            return .AlreadyReacted
        case "already_starred":
            return .AlreadyStarred
        case "bad_client_secret":
            return .BadClientSecret
        case "bad_redirect_uri":
            return .BadRedirectURI
        case "bad_timestamp":
            return .BadTimeStamp
        case "cant_delete":
            return .CantDelete
        case "cant_delete_file":
            return .CantDeleteFile
        case "cant_delete_message":
            return .CantDeleteMessage
        case "cant_invite":
            return .CantInvite
        case "cant_invite_self":
            return .CantInviteSelf
        case "cant_kick_from_general":
            return .CantKickFromGeneral
        case "cant_kick_from_last_channel":
            return .CantKickFromLastChannel
        case "cant_kick_self":
            return .CantKickSelf
        case "cant_leave_general":
            return .CantLeaveGeneral
        case "cant_leave_last_channel":
            return .CantLeaveLastChannel
        case "cant_update_message":
            return .CantUpdateMessage
        case "compliance_exports_prevent_deletion":
            return .ComplianceExportsPreventDeletion
        case "channel_not_found":
            return .ChannelNotFound
        case "edit_window_closed":
            return .EditWindowClosed
        case "file_comment_not_found":
            return .FileCommentNotFound
        case "file_deleted":
            return .FileDeleted
        case "file_not_found":
            return .FileNotFound
        case "file_not_shared":
            return .FileNotShared
        case "group_contains_others":
            return .GroupContainsOthers
        case "invalid_array_arg":
            return .InvalidArrayArg
        case "invalid_auth":
            return .InvalidAuth
        case "invalid_channel":
            return .InvalidChannel
        case "invalid_charset":
            return .InvalidCharSet
        case "invalid_client_id":
            return .InvalidClientID
        case "invalid_code":
            return .InvalidCode
        case "invalid_form_data":
            return .InvalidFormData
        case "invalid_name":
            return .InvalidName
        case "invalid_post_type":
            return .InvalidPostType
        case "invalid_presence":
            return .InvalidPresence
        case "invalid_timestamp":
            return .InvalidTS
        case "invalid_ts_latest":
            return .InvalidTSLatest
        case "invalid_ts_oldest":
            return .InvalidTSOldest
        case "is_archived":
            return .IsArchived
        case "last_member":
            return .LastMember
        case "last_ra_channel":
            return .LastRAChannel
        case "message_not_found":
            return .MessageNotFound
        case "msg_too_long":
            return .MessageTooLong
        case "migration_in_progress":
            return .MigrationInProgress
        case "missing_duration":
            return .MissingDuration
        case "missing_post_type":
            return .MissingPostType
        case "name_taken":
            return .NameTaken
        case "no_channel":
            return .NoChannel
        case "no_comment":
            return .NoComment
        case "no_reaction":
            return .NoReaction
        case "no_item_specified":
            return .NoItemSpecified
        case "no_text":
            return .NoText
        case "not_archived":
            return .NotArchived
        case "not_authed":
            return .NotAuthed
        case "not_enough_users":
            return .NotEnoughUsers
        case "not_in_channel":
            return .NotInChannel
        case "not_in_group":
            return .NotInGroup
        case "not_pinned":
            return .NotPinned
        case "not_starred":
            return .NotStarred
        case "over_pagination_limit":
            return .OverPaginationLimit
        case "paid_only":
            return .PaidOnly
        case "perimssion_denied":
            return .PermissionDenied
        case "posting_to_general_channel_denied":
            return .PostingToGeneralChannelDenied
        case "rate_limited":
            return .RateLimited
        case "request_timeout":
            return .RequestTimeout
        case "snooze_end_failed":
            return .SnoozeEndFailed
        case "snooze_failed":
            return .SnoozeFailed
        case "snooze_not_active":
            return .SnoozeNotActive
        case "too_long":
            return .TooLong
        case "too_many_emoji":
            return .TooManyEmoji
        case "too_many_reactions":
            return .TooManyReactions
        case "too_many_users":
            return .TooManyUsers
        case "unknown_type":
            return .UnknownType
        case "user_disabled":
            return .UserDisabled
        case "user_does_not_own_channel":
            return .UserDoesNotOwnChannel
        case "user_is_bot":
            return .UserIsBot
        case "user_is_restricted":
            return .UserIsRestricted
        case "user_is_ultra_restricted":
            return .UserIsUltraRestricted
        case "user_list_not_supplied":
            return .UserListNotSupplied
        case "user_not_found":
            return .UserNotFound
        case "user_not_visible":
            return .UserNotVisible
        default:
            return .UnknownError
        }
    }
}
